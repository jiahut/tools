#!/usr/bin/python3

import urllib.request as urlrequest
import json
import os
import sys

url = sys.argv[len(sys.argv) - 1]
short_url_service = 'https://www.googleapis.com/urlshortener/v1/url'
long_url = json.dumps({'longUrl': url})

request =  urlrequest.Request(short_url_service)
request.add_header('Content-Type','application/json')

opener = urlrequest.build_opener()
output = opener.open(request,bytes(long_url,'UTF-8')).read()

print(json.loads(output.decode())['id'])
