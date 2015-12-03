import psycopg2
import sys
# Try to connect

class DBConn(object):
    "Object to hold the DB connection"
    def __init__(self):
	try:
	    self.conn=psycopg2.connect("dbname='ais' user='ddmaps' password='mapapp'")
	except:
	    print "I am unable to connect to the database, exiting."
	    sys.exit()
	self.cur = self.conn.cursor()

    ais1insert = """INSERT INTO ais_1 (mmsi, lat, lon, cog, speed, status, timestamp) 
	            VALUES (%(mmsi)s, %(lat)s, %(long)s, %(cog)s, %(speed)s, %(status)s, NOW())"""
    ais1update = """UPDATE ais_1 SET lat = %(lat)s, lon = %(long)s, cog = %(cog)s, speed = %(speed)s, 
                                     status = %(status)s, timestamp = NOW()
                    WHERE mmsi = %(mmsi)s"""
    ais5insert = """INSERT INTO ais_5 (mmsi, name, type, dim_bow, dim_stern,
                                       dim_port, dim_starboard, draught, destination, eta, timestamp)
                    VALUES (%(mmsi)s,%(name)s,%(type)s,%(bow)s,%(stern)s,%(port)s,%(starboard)s,
                            %(draught)s,%(dest)s,%(eta)s,NOW())"""
    ais5update = """UPDATE ais_5 SET mmsi = %(mmsi)s, name = %(name)s, type = %(type)s, dim_bow = %(bow)s, 
                                     dim_stern = %(stern)s, dim_port = %(port)s, dim_starboard = %(starboard)s,
                                     draught = %(draught)s, destination = %(dest)s, eta = %(eta)s, timestamp = NOW()
                    WHERE CAST(mmsi AS integer) = %(mmsi)s"""

    def ais1(self, values):
        try:
            self.cur.execute(self.ais1insert, values)
        except psycopg2.IntegrityError:
            self.conn.rollback()
            #print "DUPLICATE!"
            self.cur.execute(self.ais1update, values)
        self.conn.commit()
        #print values

    def ais5(self, values):
        #print values
        try:
            self.cur.execute(self.ais5insert, values)
        except psycopg2.IntegrityError:
            self.conn.rollback()
            #print "DUPLICATE!"
            self.cur.execute(self.ais5update, values)
        self.conn.commit()
