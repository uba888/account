#!/bin/bash

#传入参数公司id,服务名,jump_url,cdn_url,personal_url
#bash replace_domain.sh 1099 defaulte http://alihuodong.clickplus.cn http://allpage.clickplus.cn http://allpersonal.clickplus.cn/
echo "更换域名步骤
1、绑定又拍云 请手动完成
2、修改数据库三个表 site,auto_tenant_upyun,auto_tenant_url
3、修改两个nginx配置"

function update_data {
	#依次修改三个表site,auto_tenant_upyun,auto_tenant_url
	#传入参数公司id,服务名,jump_url,cdn_url,personal_url
	while true;do
		echo "=================================请选择相应菜单进行操作======================================="
		echo "请选择你要进行的操作:"
		echo " 1) 查询表数据site,auto_tenant_upyun,auto_tenant_url"
		echo " 2) 更新表数据"
		echo " q) exit"
		read num
		case "$num" in
			"1")
				echo ">>>>>>site表数据:"
				mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select company,main_url,cdn_url,personalized_url from site where company=$1;"
				echo ">>>>>>auto_tenant_upyun表数据:"
				mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select tenant_id,bucket_name,url from auto_tenant_upyun where tenant_id=$1;"
				echo ">>>>>>auto_tenant_url表数据:"
				mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select tenant_id,url,type from auto_tenant_url where tenant_id=$1;";;
			"2")
				mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;update site set main_url="\""$3"\"",cdn_url="\""$4"\"",personalized_url="\""$5"\"" where company=$1;"
				mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;update auto_tenant_upyun set bucket_name="\""$2"\"",url="\""$4"\"" where tenant_id=$1;"
				mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;update auto_tenant_url set url="\""$3"\"" where tenant_id=$1 and type=1;"
				mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;update auto_tenant_url set url="\""$4"\"" where tenant_id=$1 and type=0;";;
			"q")
				echo "===退出菜单....."
				break;;
		esac
	done
}

function nginx_config {
    ##nginx跳转配置 传入jump_url,personal_url
    echo "==================================nginx跳转配置============================================="
    jump_url=`echo $1|awk -F '//' '{print $2}'`
    personal_url=`echo $2|awk -F '//' '{print $2}'`
    jump_ip=`./getip.py $jump_url`
    echo ">>>>>>jump:$jump_ip进行配置并重启 sudo sh -c \"sed -s "s/alihuodong.clickplus.cn/$jump_url/g" nginx.conf>>/etc/nginx/conf.d/vhost.conf\""
    echo ">>>>>>personal进行配置并重启 sudo sh -c \"sed -s "s/allpersonal.clickplus.cn/$personal_url/g" nginx.conf>>/etc/nginx/conf.d/vhost.conf\""
    while true;do
        echo "=================================请选择相应菜单进行操作======================================="
        echo "请选择你要进行的操作:"
        echo " 1) 重启jump的nginx"
        echo " 2) 重启个性化的nginx"
        echo " q) exit"
        read num
        case "$num" in
            "1")
                ssh -t -p 22 ops@$jump_ip "bash /alidata/account/nginx_config.sh $jump_url";;
            "2")
                ssh -t -p 22 ops@114.55.4.124 "bash /alidata/account/nginx_config.sh $personal_url";;
            "q")
                echo "===退出菜单....."
                break;;
        esac
    done
}

function data_insert {
	echo "======================================记录备份================================================="
	#传入参数：公司id,服务名,jump_url,cdn_url,personal_url
	mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use zabbix;update clickplus_account set bucket_name=\"$2\",jump_url=\"$3\",cdn_url=\"$4\",personal_url=\"$5\" where tenant_id=\"$1\";"
}


while true;do
	echo "=================================请选择相应菜单进行操作======================================="
	echo "请选择你要进行的操作:"
	echo " 1) 更新表数据"
	echo " 2) 重启nginx"
	echo " 3) 记录备份"
	echo " q) exit"
	read num
	case "$num" in
		"1")
			update_data $1 $2 $3 $4 $5;;
		"2")
			nginx_config $3 $5;;
		"3")
			data_insert $1 $2 $3 $4 $5;;
		"q")
			echo "===退出菜单....."
			break;;
	esac
done

