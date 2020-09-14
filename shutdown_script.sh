#!/bin/bash
num_users=`who -q | grep user | awk -F= '{ print $2 }'`
if [[ "$num_users" < 1 ]]; then
     /sbin/shutdown -h +1
fi
