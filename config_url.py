#!/usr/bin/python3.4
#encoding:utf-8
import requests
import sys
import json
url_config='http://camp.clickplus.cn/tenant/config_url'
headers={'X-Requested-With': 'XMLHttpRequest', 'Referer': 'http://marketingmanage.clickplus.cn/static/ajax.html', 'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36', 'Content-Type': 'application/json;charset=UTF-8'}

#参数传入顺序 公司id,站点id，服务名，jump_url,cdn_url
payload_config={"tenant_id":sys.argv[1],"site_id":sys.argv[2],"bucket_name":sys.argv[3],"jump_url":sys.argv[4],"cdn_url":sys.argv[5]}
response_config=requests.post(url_config,data=json.dumps(payload_config),headers=headers)
print(response_config.json())

