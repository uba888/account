#!/bin/bash
dbtable_root="/home/ops/MarketingCloud/DataProject/ODPS/ODPS_allin_one/odpscmd_public"
conf_root="/home/ops/MarketingCloud/DataProject/ODPS/ODPS_allin_one/WriteOdpsYun"
rsync1_root="/home/ops/MarketingCloud/DataProject/ODPS/ODPS_allin_one/BiComputeManage"
rsync2_root="/home/ops/MarketingCloud/DataProject/ODPS/ODPS_allin_one/BiComputeManageDay"
###修改odps数据表
function change_dbtable {
        echo "##公司id:$1##修改用户odps数据表:-----------------------------------------------"
        cd $dbtable_root
        sed -s "s/9999/$1/g" db_file/odps_session_table.table &&sed -i "s/9999/$1/g" db_file/odps_session_table.table
        sleep 3
        sed -s "s/9999/$1/g" db_file/odps_user_event_table.table &&sed -i "s/9999/$1/g" db_file/odps_user_event_table.table
        sleep 3
        echo ">>>>>配置修改完成，开始创建表...."
        ./bin/odpscmd -f db_file/odps_user_event_table.table
        sleep 3
        ./bin/odpscmd -f db_file/odps_session_table.table
        sleep 3
        echo ">>>>>数据表创建成功........."
        echo ">>>>>开始恢复配置..........."
        cp db_file/odps_user_event_table.table_bak db_file/odps_user_event_table.table
        cp db_file/odps_session_table.table_bak db_file/odps_session_table.table
        grep 9999 db_file/odps_session_table.table&&grep 9999 db_file/odps_user_event_table.table&&echo ">>>>>>恢>复初始化配置完成"
}
###配置数据流
function set_conf {
        echo "##公司id:$1##站点id:$2##配置数据流---------------------------------------------------"
        cd $conf_root
        cp conf/SiteDb.properties conf/SiteDb.properties_bak
        sed -i "s/$/|$2,marketingcloud_all_new,2,$1/g" conf/SiteDb.properties
        cat conf/SiteDb.properties
        echo ">>>>>>修改配置完成，重启进程"
        echo ">>>>>>旧进程"
        ps aux | grep  WriteODPSYunAllinone|grep -v 'nurse'
        kill -9 `ps aux | grep  WriteODPSYunAllinone|grep -v 'nurse'|gawk '{ print $2}'`
        echo ">>>>>>新进程"
        sleep 3
        ps aux | grep WriteODPSYunAllinone|grep -v 'nurse'
        echo ">>>>>>数据流配置完成........."
}
###加数据同步调度
function add_rsync {
        echo "##公司id:$1##添加数据同步调度---------------------------------------------------"
        cd $rsync1_root
        cp conf/manage.properties conf/manage.properties_bak
        sed -i "7 s/$/,$1/g" conf/manage.properties&&sed -n "7p" conf/manage.properties
        sleep 3
        cd $rsync2_root
        cp conf/manage.properties conf/manage.properties_bak
        sed -i "7 s/$/,$1/g" conf/manage.properties&&sed -n "7p" conf/manage.properties
        sleep 3
        echo ">>>>>>数据同步调度完成......"
}
while true; do
        echo "=============================请选择相应菜单进行操作============================"
        echo "请选择你要进行的操作:"
        echo " 0) 修改odps数据表"
        echo " 1) 配置数据流"
        echo " 2) 添加数据同步调度"
        echo " q) exit"
        read num
        case "$num" in
                "0")
                        change_dbtable $1 2>&1|tee -a /alidata/account/log/data_set.log;;
                "1")
                        set_conf $1 $2 2>&1|tee -a /alidata/account/log/data_set.log;;
                "2")
                        add_rsync $1 2>&1|tee -a /alidata/account/log/data_set.log;;
                "q")
                        echo "===退出菜单....."
                        break;;
        esac
done
echo '==================谢谢使用--Byebye====================='
