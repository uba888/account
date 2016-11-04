#!/bin/bash

cd /alidata/account



while true;do
	echo "=================================请选择相应菜单进行操作======================================="
	echo "请选择你要进行的操作:"
	echo " 1) 修改nginx.conf"
	echo " 2) 确认配置"
	echo " 3) 重启nginx"
	echo " q) exit"
	read num
	case "$num" in
		"1")
			echo ">>>>>>修改nginx.conf"
			sudo sh -c "sed -s "s/alihuodong.clickplus.cn/$1/g" nginx.conf>>/etc/nginx/conf.d/vhost.conf";;
		"2")
			echo ">>>>>>请确认配置"
			grep $1 /etc/nginx/conf.d/vhost.conf;;
		"3")
			sudo service nginx restart;;
		"q")
			echo "===退出菜单....."
			break;;
	esac
done
