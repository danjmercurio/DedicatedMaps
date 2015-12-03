import json
import urllib2
from time import time, asctime, localtime

postUrl = "http://dedicatedmaps.com/ais_feeds/"
headers = {'Content-type': 'application/json'}

class Store(object):
  "Object to post JSON web service calls."

  ais1data = dict()
  ais5data = dict() 
  
  ais1timer = time()
  ais5timer = time()
  
  def __net_open(self, req):
    try:
      response = urllib2.urlopen(req)
    except IOError, e:
      if hasattr(e,'reason'):
        print 'Failed to reach a server.'
        print 'Reason: ', e.reason
      elif hasattr(e,'code'):
        print 'Server couldn\'t fulfill the request.'
        print 'Error code: ', e.code

  def __send_ais1(self):
    jsonData = json.dumps({"ais1":self.ais1data})
    n = len(self.ais1data)
    self.ais1data.clear()
    req = urllib2.Request(postUrl + "ais1", jsonData, headers) 
    self.__net_open(req)
    print "AIS 1 " + asctime(localtime()) + ", " + `n` + " records"
    
  def __send_ais5(self):
    jsonData = json.dumps({"ais5":self.ais5data})
    n = len(self.ais5data)
    self.ais5data.clear()
    req = urllib2.Request(postUrl + "ais5", jsonData, headers)
    self.__net_open(req)
    print "AIS 5 " + asctime(localtime()) + ", " + `n` + " records"
    print req.get_full_url()
    print req.data
  def ais1(self, key, values):
    if self.ais1data.has_key(key):
      self.ais1data[key].update(values)
    else:
      self.ais1data[key] = values

    if (len(self.ais1data) % 10) == 0:
      if (time() - self.ais1timer) > 60:
        self.__send_ais1()
        self.ais1timer = time()
      
  def ais5(self, key, values):
    eta = values.get('eta',None)
    # Turn datetime into a string for JSON serialization.  But if it's a NULL and not date, just leave it as a None
    values['eta'] = eta.isoformat() if type(eta).__name__ == 'datetime' else None 
    if self.ais5data.has_key(key):
       self.ais5data[key].update(values)
    else:
       self.ais5data[key] = values

    if (len(self.ais5data) % 10) == 0:
      if (time() - self.ais5timer) > 60:
        self.__send_ais5()
        self.ais5timer = time()
     
