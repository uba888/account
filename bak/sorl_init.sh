#!/bin/bash

function sorl_init {
    echo "##公司id:$1##-----------------------------------------------"
    sorl_root="/home/ops/solr-5.5/solr-5.5.0/server/solr/good_$1/"
    mkdir "$sorl_root"
    cp -r  /home/ops/solr-5.5/conf $sorl_root
    sed -s "s/good_9999/good_$1/g" "$sorl_root"conf/schema.xml &&sed -i "s/good_9999/good_$1/g" "$sorl_root"conf/schema.xml
}
 
sorl_init $1 2>&1|tee -a /alidata/data_set/sorl_init.log
