#!/bin/bash

echo "+--------------------- Project Launch ----------------------+"
echo "|      © Text Simplification/Internship Work - 2018         |"
echo "+--------------------------------------------------------- -+"

if ! [ "$#" -eq 1 ] || ! [ -f "$1" ] || ! [[ $1 == *.txt ]]; then
  echo " Please give a text file as unique argument "
  exit 1
fi

#PARSER

XML_Directory = ''


# util now the first argument should be an XML file to split
# copy the spliting sentence into a text file
python3 _1_Split_sentence.py XML_Directory > Splitting.txt
cat Splitting.txt > ../NeuralTextSimplification/data/test.en
cat Splitting.txt > ../NeuralTextSimplification/data/test.sen

cd ../NeuralTextSimplification/src/scripts/
source translate.sh

cd ../../results_NTS

value=$(<result_NTS_epoch11_10.19.t7_5)
echo "$value"

echo "" > results_NTS # clear results file

rm "$XML_Directory/*" # remove all XML files