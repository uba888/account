#!/usr/bin/python3.4
#encoding:utf-8
import requests
import sys
import json
url_mongo='http://camp.clickplus.cn/tenant/add_to_mongo'
payload_mongo={'tenant_id':sys.argv[1]}
headers={'X-Requested-With': 'XMLHttpRequest', 'Referer': 'http://marketingmanage.clickplus.cn/static/ajax.html', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36', 'Content-Type': 'application/json;charset=UTF-8'}
response_mongo_add=requests.post(url_mongo,data=json.dumps(payload_mongo),headers=headers)
print(response_mongo_add.json())
