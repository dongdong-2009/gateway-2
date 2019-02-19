#!/bin/sh

 ubus list device | grep device > /dev/null
 if [ $? -eq 1 ]
 then
     echo 'device restart'
     /etc/init.d/device restart
 fi