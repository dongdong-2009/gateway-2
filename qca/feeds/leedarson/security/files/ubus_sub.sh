#!/bin/sh

if [ "$#" -ne "1" ] ; then
   echo "usage: $0 xxxx"
   exit 1
fi

echo "wait for $1"
ubus wait_for $1

if [ $? != 0 ] ; then
   echo "$1 does not online"
   exit 2
fi

/usr/bin/sec_sub $1

