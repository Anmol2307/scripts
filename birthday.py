## commenting
import json

import urllib

import urllib2

userid = "userid"

access_token = "access-token"

proxyname="proxyname"

proxyport="proxy"

username="username"

pass="pass"

posts_url = "https://graph.facebook.com/"+userid+"/posts?access_token="+access_token

proxy_support = urllib2.ProxyHandler({'http':'http://'+username+':'+pass+'@'+proxyname+':'+proxyport,
									  'https':'https://'+username+':'+pass+'@'+proxyname+':'+proxyport})
opener = urllib2.build_opener(proxy_support)
urllib2.install_opener(opener)
#retrieving the content.
print posts_url
req = urllib2.Request(posts_url)
response = urllib2.urlopen(req)
the_page = response.read()

array = json.loads(the_page);

array = array["data"];

for item in array:

	message = "None Type"
	if item.has_key("message"):
		message = item["message"]

	object_id = "None Type"
	if item.has_key("object_id"):
		object_id = item["object_id"]
		print "message:-- ",message
		print object_id

		print "Type your comment!!"
		comment_message = raw_input()
		data = urllib.urlencode({'message': comment_message,'access_token':access_token})
		comment_url = "https://graph.facebook.com/"+object_id+"/comments"
		u = urllib2.urlopen(comment_url, data)

		for line in u.readlines():
  			print line
