#!/bin/bash

echo "Домашний каталог пользователя\n $USER"
echo "Содержит обычных файлов: "
find ~/ -maxdepth 1 -type f \! -name ".*" | wc -l

echo "Содержит скрытых файлов: "
find ~/ -maxdepth 1 -type f -name ".*" | wc -l
