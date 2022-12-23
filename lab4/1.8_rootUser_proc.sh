#!/bin/bash
echo "Процессов пользователя $(whoami);:";
ps -U "$(whoami)" | wc -l;
echo "Процессов пользователя root:";
ps -U root | wc -l;
