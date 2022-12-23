#!/bin/bash
ps -eo euser,ruser,comm --no-headers | awk '{if ($1 != $2) print $3}'
