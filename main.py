#!/usr/bin/python3.4

import requests
import json
import os,sys,pymysql
import shutil


def replace_content(*args):
	##替换函数 需要编辑的文件 被替换的字符串 提成成的字符串 [另存成的文件]
    len_argv=len(args)
    #print '传参数量',len_argv-1

    if   len_argv <  3:
        print("参数错误 需要编辑的文件 被替换的字符串 提成成的字符串 [另存成的文件]")

    elif len_argv >  4:
        print("参数错误 需要编辑的文件 被替换的字符串 提成成的字符串 [另存成的文件]")

    else:
        if not os.path.isfile(args[0]):
            print('文件不存在')
            sys.exit()
        s_file  = open(args[0],'r+')
        old_str = args[1]
        new_str = args[2]
        d_file  = open(args[0]+'.tmp','w')
        for line in s_file.readlines():
            d_file.writelines(line.replace(old_str,new_str))
        s_file.close()
        d_file.close()

        if len_argv == 3:
            os.rename(args[0]+'.tmp',args[0])
        else:
            os.rename(args[0]+'.tmp',args[3])


'''传入参数：公司名称,邮箱,服务名，jump_url,cdn_url,personal_url'''


def tenant_add(company_name,email):
	'''添加公司（公司名称,邮箱）tenant_add(company_name,email)'''
	print("==================================添加公司=============================================")
	url='http://marketingmanage.clickplus.cn/tenant/create'
	headers={'X-Requested-With': 'XMLHttpRequest', 'Referer': 'http://marketingmanage.clickplus.cn/static/ajax.html', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36', 'Content-Type': 'application/json;charset=UTF-8'}
	payload={"contactName": "活动管理员", "companyName":company_name, "roleName": "活动管理员", "email":email}
	response_tenant_add=requests.post(url,data=json.dumps(payload),headers=headers)
	print(response_tenant_add.json())

def mongo_add(email):
	#mongo数据初始化 公司id
	print("================================mongo数据初始化==========================================")
	url_mongo='http://camp.clickplus.cn/tenant/add_to_mongo'
	cursor.execute("select TenantID from t_tenantuser where Email=\"%s\"" % email)
	tenantid=cursor.fetchall()[0][0]
	payload_mongo={'tenant_id':tenantid}
	headers={'X-Requested-With': 'XMLHttpRequest', 'Referer': 'http://marketingmanage.clickplus.cn/static/ajax.html', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36', 'Content-Type': 'application/json;charset=UTF-8'}
	response_mongo_add=requests.post(url_mongo,data=json.dumps(payload_mongo),headers=headers)
	print(response_mongo_add.json())

def sorl_init(email):
	#sorl初始化 tenant_id
	print("=================================sorl初始化===============================================")
	cursor.execute("select TenantID from t_tenantuser where Email=\"%s\"" % email)
	tenantid=cursor.fetchall()[0][0]
	sorl_root="/home/ops/solr-5.5/solr-5.5.0/server/solr/good_%s/" % str(tenantid)
	os.mkdir(sorl_root)
	shutil.copytree('/home/ops/solr-5.5/conf',"/home/ops/solr-5.5/solr-5.5.0/server/solr/good_%s/conf" % tenantid)
	replace_content("/home/ops/solr-5.5/solr-5.5.0/server/solr/good_%s/conf/schema.xml" % str(tenantid),'good_9999','good_%s' % str(tenantid))
	os.system('/home/ops/solr-5.5/solr-5.5.0/bin/solr stop -p 8983')
	os.system('/home/ops/solr-5.5/solr-5.5.0/bin/solr start -p 8983')
	print(">>>>>>请进入 http://120.27.146.30:8983/solr/#/~cores/good_3 手动添加good_%s" % str(tenantid))	
		



def site_create():
	#创建站点
	print("=================================创建站点==================================================")

def cdn_create():
	#创建cdn
	print("======================================创建cdn==============================================")


def config_url():
	#创建基础网站数据
	print("=====================================创建基础网站数据=======================================")

def personal_add():
	#添加个性化
	print("====================================添加个性化==============================================")

def nginx_reboot():
	#nginx跳转配置
	print("========================================nginx跳转配置========================================")


def data_set():
	#数据流配置
	print("=========================================数据流配置=========================================")

def data_delete():
	#删除数据
	print("=========================================删除数据===========================================")

def reply():
	#完成开通进行回复
	print("======================================完成开通进行回复======================================")

def bak():
	#记录备份
	print("=======================================记录备份==============================================")

if __name__=="__main__":
	conn=pymysql.connect(user='jdyun_ops',host='114.55.21.195',password='Jdyun123456',database='marketingcloud_business')
	cursor=conn.cursor()
	print(sys.argv[1])
	while True:
		print('''1) 添加公司
 2) mongo数据初始化
 3) sorl初始化
 4) 登录用户管理项目并创建站点
 5) 创建cdn服务
 6) 创建基础网站数据
 7) 添加个性化
 8) nginx跳转配置
 9) 数据配置
 d) 删除数据
 f) 完成开通，进行回复
 b) 记录备份
 q) exit''')
		
		choice=input("请选择你要进行的操作:")
		if choice == "1":
			print(111)		
		elif choice == "2":
			mongo_add(sys.argv[2])		
		elif choice == "3":
			sorl_init(sys.argv[2])
