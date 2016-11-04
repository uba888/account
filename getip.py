#!/usr/bin/python3.4
#encoding:utf-8
import socket
import urllib.request
import sys
add=sys.argv[1]
ip=socket.getaddrinfo(add,'http')[0][4][0]
print(ip)
