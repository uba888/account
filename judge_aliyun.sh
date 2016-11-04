#!/bin/bash
#传入参数 申请人，邮箱，域名，服务名，公司
#获取参数 阿里云，时间
#使用方法:bash judge_aliyun.sh 乌巴 455792616@qq.com clickplus.cn defaulte 太极

#插入数据库
#mysql -uroot -pq -e "use cs;insert into clickplus_account1 (apply_date,applyer,company,email,domain,aliyun,bucket_name) values(20161103,'杨莉','九休旅游','mahw@jiuxiulvxing.com','m.jiuxiulvxing.com','no','defaulte')"

function insert_date {
	#插入数据库
	#传入参数 时间，申请人，公司，邮箱，域名，阿里云，服务名
	#mysql -uroot -pq -e "use cs;insert into clickplus_account1 (apply_date,applyer,company,email,domain,aliyun,bucket_name) values(20161103,'杨莉','九休旅游','mahw@jiuxiulvxing.com','m.jiuxiulvxing.com','no','defaulte')"
	echo "=============================================插入数据库==============================================="
	#mysql -uroot -pq -e "use cs;insert into clickplus_account1 (apply_date,applyer,company,email,domain,aliyun,bucket_name) values($1,\"$2\",\"$3\",\"$4\",\"$5\",\"$6\",\"$7\")"
	mysql -h114.55.21.195 -ujdyun_ops -pJdyun123456 -e "use zabbix;insert into clickplus_account (apply_date,applyer,company,email,domain,aliyun,bucket_name) values($1,\"$2\",\"$3\",\"$4\",\"$5\",\"$6\",\"$7\")"
	echo "插入成功.........."
}



function reply_config {
	#返回开账号信息
	#传入阿里云参数，服务名,公司
	echo "=============================================回开账号信息============================================="
	if [ "$1" = "YES" ]
	then
		echo "你好！$3的域名配置：
请让客户按以下信息增加子域名后提供活动链接域名和页面域名给我们，谢谢！
活动链接域名指向： 120.27.146.30  dns记录类型：a记录
页面域名指向  $2.b0.upaiyun.com dns记录类型：cname记录
个性化页面域名指向  114.55.4.124 dns记录类型：a记录
例如：
客户主域名为www.xxx.com  dns设置如下：
活动链接域名指向：huodong.xxx.com  120.27.146.30  dns记录类型：a记录
页面域名：  page.xxx.com  $2.b0.upaiyun.com dns记录类型：cname记录
个性化页面域名：personal.xxx.com  114.55.4.124 dns记录类型：a记录"
	elif [ $1 = 'NO' ]
	then
		echo "你好！$3的域名配置：
请让客户按以下信息增加子域名后提供活动链接域名和页面域名给我们，谢谢！
活动链接域名指向： 47.90.36.23  dns记录类型：a记录
页面域名指向  $2.b0.upaiyun.com dns记录类型：cname记录
个性化页面域名指向  114.55.4.124 dns记录类型：a记录

例如：
客户主域名为www.xxx.com  dns设置如下：
活动链接域名指向：huodong.xxx.com  47.90.36.23  dns记录类型：a记录
页面域名：  page.xxx.com  $2.b0.upaiyun.com dns记录类型：cname记录
个性化页面域名：personal.xxx.com  114.55.4.124 dns记录类型：a记录"
	fi
}

#域名判断，传入域名信息
tag_aliyun=`./ip_addr.py $3`

#时间获取
tag_date=`date +%Y%m%d`

while true;do
	echo "=============================请选择相应菜单进行操作============================"
	echo "请选择你要进行的操作:"
	echo " 0) 返回开账号信息"
	echo " 1) 插入数据库"
	echo " q) exit"
	read num
	case "$num" in
		"0")
			reply_config $tag_aliyun $4 $5;;
		"1")
			insert_date $tag_date $1 $5 $2 $3 $tag_aliyun $4;;
		"q")
			echo "===退出菜单....."
			break;;
	esac
done
echo '==================谢谢使用--Byebye====================='
