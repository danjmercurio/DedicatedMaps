
#!/usr/bin/python

""" Read AIS data from a list of TCP/IP ports.
"""
#from socket import socket, AF_INET, SOCK_STREAM
import socket
from select import poll, POLLIN
import sys
import ais_parse
import json_call 

store = json_call.Store()

debug = True    # Log debugging messages?
def dlog(msg):  
    print(msg)  #Cheezy simple "log" for now


def sockify(addr):   # Takes an addres, port pair, returns a network socket connected to that.
    HOST, PORT = addr
    for res in socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC, socket.SOCK_STREAM):
        af, socktype, proto, canonname, sa = res
        try:
            s = socket.socket(af, socktype, proto)
        except socket.error as msg:
            print "Failed to create socket for" + str(addr)
            s = None
            continue
        try:
            s.connect(sa)
        except socket.error as msg:
            s.close()
            s = None
            print "Failed to connect to " + str(addr)
            continue
        break
    if s is None:
        return
    else:
        return s

#sources = [('216.177.253.143', 3131), ('208.79.150.114', 1001)]

#sources = [('216.177.253.143', 3131), ('206.72.107.155', 1007)]

sources = [('216.177.253.143', 3131)]


#,  # bar pilots
           #('206.72.107.155', 1000),   # exchange
               # puget sound
           #('vts2.concentriamaritime.com', 12009)]  # Mississippi River Maritime Assoc
sockets = map(sockify, sources)  # Yield a list of sockets
print "Sockets: " + str(sockets)

# A dictionary of file wrappers around the sockets, keyed by file descriptor.
handles = dict((sock.fileno(), sock.makefile('r')) for sock in sockets)  

# Create a poll object, and register all the sockets with with it for INput events.
p = poll()
for socket in sockets:
    p.register(socket,POLLIN)

# Loop forever
while True:
    readies = p.poll()  #poll() waits until something happens, then returns a list of what happened.
    #print(readies)
    for (fd, event) in readies:
        data = handles[fd].readline()
	try:
	    parsed = ais_parse.parse(data)
	except:
	    parsed = 'None'
	if str(parsed) != 'None':
	    (type, key, values) = parsed
	    dlog((readies, type, values)) if debug else None 
	    store.__getattribute__(type)(key, values)
    
for sock in sockets:  # Close up all the sockets when done.
    sock.close()
