#!/bin/bash -ex
# build Debian repository metadata for ./*.deb
apt-ftparchive packages . > Packages
apt-ftparchive contents . > Contents
apt-ftparchive -c release.conf release . > Release
gzip -9 --force Packages Contents Release

