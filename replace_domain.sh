#!/bin/bash

#传入参数公司id,服务名,jump_url,cdn_url,personal_url
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

update_data $1 $2 $3 $4 $5
