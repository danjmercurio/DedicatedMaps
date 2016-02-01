#!/bin/bash
# This script should be run on server boot to start a worker process for Backburner.
# This is to handle asychronously POST requests to /staging_area_feeds
su - deploy -c 'god -c /home/deploy/dedicatedmaps/config/backburner.god'
echo 'Worker for Backburner gem started.'
exit 0



