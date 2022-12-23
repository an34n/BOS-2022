#!/bin/bash 

cat bash.txt | grep "000000" > /tmp/zeros

cat bash.txt | grep -v "000000" > /tmp/nozeros

echo "Первые 10 строк /tmp/zeros"
head -10 /tmp/zeros

echo "Последние 10 строк /tmp/zeros"

tail -10 /tmp/zeros

echo "Первые 10 строк /tmp/nozeros"
head -10 /tmp/nozeros

echo "Последние 10 строк /tmp/nozeros"
tail -10 /tmp/nozeros
