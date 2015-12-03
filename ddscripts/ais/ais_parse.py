#!/usr/bin/python

""" Parse incoming AIS data.
"""
import sys
import aisparser

from datetime import datetime

months = [ "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]

defaults = {'lat':0, 'long':0, 'cog':0, 'speed':0, 'status':0, 'destination':'', 'type':0, 'name':'' ,'draught':0, 'dim_bow':0, 'dim_stern':0, 'dim_port':0, 'dim_starboard':0, 'eta': None}

def scrub(data):
  result = {}
  for key, value in data.items():
    if value != defaults[key]: result[key] = value
  return result

def calc_eta( eta ):
  min  = eta & 0x3F
  hour = (eta >> 6) & 0x1F
  day  = (eta >> 11) & 0x1F
  month= (eta >> 16) & 0x0F
  year = 1900
  dt = None
  try:
    dt = datetime(year, month, day, hour, min)
  except:
    sys.stderr.write("Error with passed date: eta %d parsed into %d %d %d %d %d \n" % (eta, year, month, day, hour, min))
  return dt

def debug_hash(hash):
  for key, value in hash.items():
    print "%s: %s" % (key, value)

# Setup for AIS Parser
ais_state = aisparser.ais_state()

def parse(data):
  # Parse the data
  result = aisparser.assemble_vdm( ais_state, data )
  if result == 0:
    ais_state.msgid = aisparser.get_6bit( ais_state.six_state, 6 )

    # Message 1: Position Update
    if ais_state.msgid == 1:
      msg = aisparser.aismsg_1()
      aisparser.parse_ais_1( ais_state, msg )
      msg.msgid = 1
      (status,lat_dd,long_ddd) = aisparser.pos2ddd( msg.latitude, msg.longitude );
      hash = {'lat':lat_dd, 'long':long_ddd, 'cog':msg.cog / 10, 'speed':msg.sog / 100, 'status':ord(msg.nav_status)}
      return("ais1", msg.userid, scrub(hash))

    # Message 2: Position Update
    elif ais_state.msgid == 2:
      msg = aisparser.aismsg_2()
      aisparser.parse_ais_2( ais_state, msg )
      msg.msgid = 2
      debug_hash(msg)

    # Message 3: Position Update
    elif ais_state.msgid == 3:
      msg = aisparser.aismsg_3()
      aisparser.parse_ais_3( ais_state, msg )
      msg.msgid = 3
      debug_hash(msg)

    # Message 4: Base Station Report
    elif ais_state.msgid == 4:
      msg = aisparser.aismsg_4()
      aisparser.parse_ais_4( ais_state, msg )
      msg.msgid = 4
      debug_hash(msg)

    # Message 5: Ship Static and Voyage Data
    elif ais_state.msgid == 5:
      msg = aisparser.aismsg_5()
      aisparser.parse_ais_5( ais_state, msg )
      msg.msgid = 5
      eta = calc_eta(msg.eta) if msg.eta != 49152 and msg.eta != 1596 and msg.eta != 0 else None

      msg.callsign = msg.callsign.replace('@', ' ').rstrip()
      msg.name = msg.name.replace('@', ' ').strip()
      msg.dest = msg.dest.replace('@', ' ').strip()
      hash = {'destination':msg.dest, 'type': msg.ship_type, 'name': msg.name , 'dim_bow': msg.dim_bow, 'dim_stern': msg.dim_stern, 'dim_port': ord(msg.dim_port), 'dim_starboard': ord(msg.dim_starboard), 'draught': msg.draught, 'eta': eta }
      return("ais5", msg.userid, scrub(hash))

    # Message 18: Class B Position Report
    elif ais_state.msgid == 18:
      msg = aisparser.aismsg_18()
      aisparser.parse_ais_18( ais_state, msg )
      msg.msgid = 18
      (status,lat_dd,long_ddd) = aisparser.pos2ddd( msg.latitude, msg.longitude );
      hash = {'lat':lat_dd, 'long':long_ddd, 'cog':msg.cog / 10, 'speed':msg.sog / 100 }
      return("ais1", msg.userid, scrub(hash))

    # Message 19: Class B Position + Ship Name
    elif ais_state.msgid == 19:
      msg = aisparser.aismsg_19()
      aisparser.parse_ais_19( ais_state, msg )
      msg.msgid = 19
      msg.name = msg.name.replace('@', ' ').strip()
      debug_hash(msg)

    # Message 24: Class B ship Name
    elif ais_state.msgid == 24:
      msg = aisparser.aismsg_24()
      aisparser.parse_ais_24( ais_state, msg )
      msg.msgid = 24
      msg.callsign = msg.callsign.replace('@', ' ').strip()
      msg.name = msg.name.replace('@', ' ').strip()
      hash = {'type': msg.ship_type, 'name': msg.name , 'dim_bow': msg.dim_bow, 'dim_stern': msg.dim_stern, 'dim_port': ord(msg.dim_port), 'dim_starboard': ord(msg.dim_starboard), 'eta': None}
      return("ais5", msg.userid, scrub(hash))

