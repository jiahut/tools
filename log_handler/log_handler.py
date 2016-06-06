#!/bin/env python
import re

phone = re.compile("(\d{3})(\d{4})(\d{4})")
with open("/tmp/text.log") as r:
    with open("/tmp/text.after.log","a") as w:
	    for line in r:
		#if phone.match(line):
		# res = phone.search(line)
		#res = phone.sub("**", line)
	        # print(line)
		sub_phone = phone.sub(r"\1****\3", line)
		w.write(sub_phone)
 
