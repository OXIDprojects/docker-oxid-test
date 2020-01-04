#!/bin/bash
echo starting routing from socket to 3306
nohup socat TCP-LISTEN:3306,reuseaddr,fork UNIX-CLIENT:/var/run/mysqld/mysqld.sock </dev/null &>/dev/null &
echo done. You can now use 127.0.0.1 as db host
