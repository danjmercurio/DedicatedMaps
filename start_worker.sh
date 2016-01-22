#!/bin/bash
bundle exec backburner -q newsletter-sender,push-notifier -d -P /var/run/backburner.pid -l /var/log/backburner.log
