#!/usr/bin/python3.4
#encoding:utf-8
import socket
import urllib.request
import sys
add=sys.argv[1]
if add.count('.')>=2:
	add=add[add.rfind('.',1,add.rfind('.'))+1:]
try:
	ip=socket.getaddrinfo(add,'http')[0][4][0]
except socket.gaierror as reason:
	add='www.'+add
	ip=socket.getaddrinfo(add,'http')[0][4][0]
response=urllib.request.urlopen("http://api.ip138.com/query/?ip=%s&datatype=jsonp&token=4d977467f918b9c90b242ce0fc20b069" % ip)
result=response.read().decode("utf-8")
if '阿里云' in result:
	print('YES')
else:
	print('NO')

