#!/bin/bash -ex
# creates a Confluence debian package
# based on http://tldp.org/HOWTO/html_single/Debian-Binary-Package-Building-HOWTO/

# Confluence version to package 
#ver=4.2.4
archive=atlalssian-confluence-4.2.4

ver=3.5.16
archive=confluence-3.5.16-std

# debian revision
rev=0

wget -N http://www.atlassian.com/software/confluence/downloads/binary/$archive.tar.gz 

base=$PWD

rm -rf debian || true
mkdir debian
cd debian
root=$PWD

# control files and metadata
mkdir DEBIAN
cat > DEBIAN/control << EOF
Package: atlassian-confluence
Version: $ver-$rev
Section: base
Priority: optional
Architecture: all
Depends: coreutils, openjdk-6-jre
Maintainer: Kohsuke Kawaguchi <kk@kohsuke.org>
Description: Atlassian Confluence
EOF
cp $base/postinst DEBIAN/postinst


# main binary
mkdir -p srv/wiki
pushd srv/wiki
  tar xzf $base/$archive.tar.gz
  # symlink to the current version
  ln -s $archive current
popd

# init script
mkdir -p etc/init.d
pushd etc/init.d
  cp $base/confluence.init confluence
popd

# default settings
mkdir -p etc/default
pushd etc/default
  cp $base/confluence.default confluence
popd
echo /etc/default/confluence > DEBIAN/conffiles

# move $HOME/conf to /etc
mkdir -p etc/confluence
pushd srv/wiki/current
  mv conf $root/etc/confluence/conf
  ln -s ../../../etc/confluence/conf .
popd

# tell dpkg that everything in /etc/confluence is configuration files
(find etc/confluence -type f) | sed -e 's#^#/#' >> DEBIAN/confflies

# ditto for files in $HOME/confluence/WEB-INF/classes
# TODO: I originally tried to move them into /etc/confluence and symlinks, but JVM didn't like that
pushd srv/wiki/current/confluence/WEB-INF/classes
  files="$(ls *.properties *.xml)"
  for f in $files; do
    echo /srv/wiki/$archive/confluence/WEB-INF/classes/$f >> $root/DEBIAN/conffiles
  done
popd

pushd etc/confluence
  ln -s ../../srv/wiki/current/confluence/WEB-INF/classes/ WEB-INF-classes
popd

# build a package
cd ..
fakeroot dpkg-deb --build debian apt-repo/atlassian-confluence_${ver}-${rev}_all.deb
cp apt-repo/*.deb ../modules/confluence/files
