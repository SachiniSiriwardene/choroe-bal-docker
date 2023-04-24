#!/bin/sh

redis-server --daemonize yes


java -Xdiag -cp "/home/ballerina/greeting_service.jar:jars/*" 'bfsitest.greeting_service.3.$_init'

