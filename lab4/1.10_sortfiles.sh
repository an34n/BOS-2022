#!/bin/bash

du ~ -a 2>/dev/null | sort -k1 | cut -f2
