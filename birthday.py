## commenting
import json

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

print the_page
