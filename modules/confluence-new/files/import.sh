: ${BACKUP:=/tmp/vagrant-puppet/modules-0/work}

# load database dump while switching back to InnoDB
gunzip -c $BACKUP/backup.db.gz| sed -e 's/ENGINE=MyISAM/Engine=InnoDB/g' | mysql -p confluence

# restore home dir
mkdir home
cd home
tar xvzf $BACKUP/backup.fs.gz

# TODO: touch confluence-cfg.xml and edit connection and license

# TODO: set  <property name="hibernate.connection.isolation">2</property>