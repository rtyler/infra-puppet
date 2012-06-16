#!/bin/bash
# convert all MyISAM tables to InnoDB
# see https://confluence.atlassian.com/pages/viewpage.action?pageId=192872609
for t in $(echo show table status | mysql confluence | grep MyISAM | cut -f1);
do
    echo $t
    echo alter table $t ENGINE=innodb | mysql confluence;
done