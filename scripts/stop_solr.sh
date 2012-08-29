#!/bin/sh
jps -l | grep start.jar | cut -d ' ' -f 1 | xargs -rn1 kill
