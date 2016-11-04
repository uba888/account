#!/bin/bash
#encoding utf-8
##使用方法 bash main.sh 公司名称,邮箱,服务名，jump_url,cdn_url,personal_url

function sorl_init {
    ##sorl目录配置创建,以及sorl重启,进入网站手动添加core
	echo "==================================sorl初始化============================================="
    tenant_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select TenantID from t_tenantuser where Email=\"$2\";"|sed -n '2p'`
	echo "##`date +%y%m%d%H%M`##-----------------------------------------------"
    sorl_root="/home/ops/solr-5.5/solr-5.5.0/server/solr/good_$tenant_id/"
    mkdir "$sorl_root"
    cp -r  /home/ops/solr-5.5/conf $sorl_root
    sed -s "s/good_9999/good_$tenant_id/g" "$sorl_root"conf/schema.xml &&sed -i "s/good_9999/good_$tenant_id/g" "$sorl_root"conf/schema.xml
	/home/ops/solr-5.5/solr-5.5.0/bin/solr stop -p 8983
	sleep 3
	/home/ops/solr-5.5/solr-5.5.0/bin/solr start -p 8983
	echo ">>>>>>请进入 http://120.27.146.30:8983/solr/#/~cores/good_3 手动添加core"
}


function tenant_add {
	echo "==================================添加公司============================================="
	##添加公司，使用tenant_add.py 调用requests发送post请求
	##使用方法：./tenant_add.py 公司名称 邮箱
	./tenant_add.py $1 $2
}

##查询公司id
#tenant_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select TenantID from t_tenantuser where Email=$2;"|sed -n '2p'`

function mongo_add {
	echo "==================================mongo数据初始化============================================="
	##mongo数据初始化
	##使用方法 ./mongo_add.py 公司id
	tenant_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select TenantID from t_tenantuser where Email=\"$2\";"|sed -n '2p'`
	./mongo_add.py $tenant_id
}
##sorl初始化
#sorl_init $tenant_id

##登录用户管理项目并创建网站，手动完成
function site_create {
	echo "==================================创建站点============================================="
	echo ">>>>>>登录用户管理项目并创建网站，手动完成 http://marketingmanage.clickplus.cn/"
    echo "账号：$2 活动站点：$4"
}

##站点创建成功后查询站点id
##site_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e 'use marketingcloud_business;select idsite from site where company=1099;'|sed -n '2p'`

##创建cdn服务
function cdn_create {
	echo "==================================创建cdn服务============================================="
	echo ">>>>>>登录https://console.upyun.com 绑定cdn域名:$1"
}

function config_url {
	##创建基础网站数据
	##参数传入顺序 公司id,站点id，服务名，jump_url,cdn_url
	echo "==================================创建基础网站数据============================================="
	tenant_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select TenantID from t_tenantuser where Email=\"$2\";"|sed -n '2p'`
	site_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select idsite from site where company=$tenant_id;"|sed -n '2p'`
    ./config_url.py $tenant_id $site_id $3 $4 $5 
}

function add_personal {
	echo "===================================添加个性化============================================"
	tenant_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select TenantID from t_tenantuser where Email=\"$2\";"|sed -n '2p'`
    site_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select idsite from site where company=$tenant_id;"|sed -n '2p'`
	##修改mysql site表的personalized_url
	mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;update site set personalized_url=\"$6\" where idsite=$site_id;"

	##查询确认
	mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select * from site where idsite=$site_id;"

	###开通个性化
	mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;insert into auto_tenant_service values($tenant_id,1,0)"
	###查询确认
	mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select * from auto_tenant_service where tenant_id=$tenant_id"
}

function nginx_config {
	##nginx跳转配置 传入jump_url,personal_url
	echo "==================================nginx跳转配置============================================="
	jump_url=`echo $1|awk -F '//' '{print $2}'`
    personal_url=`echo $2|awk -F '//' '{print $2}'`
    jump_ip=`./getip.py $jump_url`
    echo ">>>>>>jump:$jump_ip手动进行配置并重启 sudo sh -c \"sed -s "s/alihuodong.clickplus.cn/$jump_url/g" nginx.conf>>/etc/nginx/conf.d/vhost.conf\""
    echo ">>>>>>personal手动进行配置并重启 sudo sh -c \"sed -s "s/allpersonal.clickplus.cn/$personal_url/g" nginx.conf>>/etc/nginx/conf.d/vhost.conf\""
}


function data_set {
	echo "======================================数据配置================================================="
	echo ">>>>>>数据配置使用方法：执行bash data_set.sh tenant_id site_id"	
    tenant_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select TenantID from t_tenantuser where Email=\"$2\";"|sed -n '2p'`
    site_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select idsite frOm site where company=$tenant_id;"|sed -n '2p'`
    bash data_set.sh $tenant_id $site_id
    echo "客户:$1
邮箱:$2
账号开好了，测试下"
}

function delete_data {
    echo "======================================删除数据================================================="
    echo "用法:bash delete_data.sh $tenant_id"
    tenant_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select TenantID from t_tenantuser where Email=\"$2\";"|sed -n '2p'`
    bash delete_data.sh $tenant_id

}


function reply {
	echo "hi   你好！
账号开好了。
账号：$2
密码：123456
地址：camp.clickplus.cn
PS：目前账号开通的域名配置按照默认域名进行配置的，如果客户需要修改请联系我们，谢谢！"
}

function insert_data {
	echo "======================================记录备份================================================="
	#传入参数：公司id,站点id,jump_url,cdn_url,personal_url,email
	tenant_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select TenantID from t_tenantuser where Email=\"$2\";"|sed -n '2p'`
    site_id=`mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use marketingcloud_business;select idsite frOm site where company=$tenant_id;"|sed -n '2p'`
	mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use zabbix;update clickplus_account set finish='YES',tenant_id=$tenant_id,site_id=$site_id,jump_url=\"$4\",cdn_url=\"$5\",personal_url=\"$6\" where email=\"$2\";"
	echo ">>>>>>>备份成功......"
}



while true; do
	echo "=================================请选择相应菜单进行操作======================================="
	echo "请选择你要进行的操作:"
	echo " 1) 添加公司"
	echo " 2) mongo数据初始化"
	echo " 3) sorl初始化"
	echo " 4) 登录用户管理项目并创建站点"
	echo " 5) 创建cdn服务"
	echo " 6) 创建基础网站数据"
	echo " 7) 添加个性化"
	echo " 8) nginx跳转配置"
	echo " 9) 数据配置"
	echo " d) 删除数据"
    echo " f) 完成开通，进行回复"
	echo " b) 记录备份"
	echo " q) exit"
	read num
	case "$num" in
		"1")
			tenant_add $1 $2;;
		"2")
			mongo_add $1 $2;;
		"3")
			sorl_init $1 $2;;
		"4")
			site_create $1 $2 $3 $4;;
		"5")
			cdn_create $5;;
		"6")
			config_url $1 $2 $3 $4 $5;;
		"7")
			add_personal $1 $2 $3 $4 $5 $6;;
		"8")
			nginx_config $4 $6;;
		"9")
			data_set $1 $2;;
        "d")
            delete_data $1 $2;;
		"f")
			reply $1 $2;;	
        "b")
			insert_data $1 $2 $3 $4 $5 $6;;
		"q")
			echo "===退出菜单....."
			break;;
	esac
done
