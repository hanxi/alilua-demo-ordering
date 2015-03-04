#!/bin/sh

filepath=$(cd "$(dirname "$0")"; pwd)

stop()
{
    pid=`ps -ef| grep "alilua" | grep -v grep | awk '{print $2}' `
    if [ "$pid"x != x ]; then
        kill -9 $pid
        echo "stop alilua"
    fi
}

start()
{
    echo "start alilua prot:9999"
    $filepath/alilua/alilua process=4 bind=9999 daemon host-route=$filepath/host-route.lua
    echo "ok"
}

stop
start

if [ ! -d $filepath/uploaddir ]; then
    mkdir $filepath/uploaddir
fi

