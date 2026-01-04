#!/bin/bash
ps -eo pid,ppid,state,cmd | awk '$3=="Z" {print $2}' | sort -u | xargs -r kill -9
