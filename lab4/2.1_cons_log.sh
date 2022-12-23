#!/bin/bash

date >> /tmp/run.log
echo "Hello world"
cat /tmp/run.log | wc -l >&2
