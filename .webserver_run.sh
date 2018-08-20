#!/bin/bash

# This file is only used by the website to use the makefile

echo "+--------------------- System Launch ----------------------+"
echo "|      © Text Simplification | SENTS-reproduction - 2018         |"
echo "+--------------------------------------------------------- -+"

cd ..

# $1 is the full path of the file, so pay attention on your makefile while passing the path
make file=$1
