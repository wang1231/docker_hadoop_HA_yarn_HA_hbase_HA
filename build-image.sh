#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop image\n"
sudo docker build -t wangsongbai/hadoop:2.0 .

echo ""