#!/bin/bash

source ./utils.sh

function clear_with_file() {
    clear_with_hat
    stat $FILENAME | head -4 | prSection 4
}


