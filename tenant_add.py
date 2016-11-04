#!/usr/bin/python3.4
#encoding:utf-8
import requests
import sys
import json
url='http://marketingmanage.clickplus.cn/tenant/create'
headers={'X-Requested-With': 'XMLHttpRequest', 'Referer': 'http://marketingmanage.clickplus.cn/static/ajax.html', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36', 'Content-Type': 'application/json;charset=UTF-8'}
payload={"contactName": "活动管理员", "companyName":sys.argv[1], "roleName": "活动管理员", "email":sys.argv[2]}
response_tenant_add=requests.post(url,data=json.dumps(payload),headers=headers)
print(response_tenant_add.json())

