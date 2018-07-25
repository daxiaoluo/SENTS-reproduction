#!/bin/bash

# Change these to make them work everywhere
WORK_DIR=$PWD
UCCA_DIR=$WORK_DIR/UCCA_Parser
SCRIPTS=$WORK_DIR/scripts

file=$1
filename="${file##*/}"
article_name="${filename%.*}"

echo "+--------------------- Project Launch ----------------------+"
echo "|      © Text Simplification/Internship Work - 2018         |"
echo "+--------------------------------------------------------- -+"


# Test if text file (to change)
if ! [ "$#" -eq 1 ] || ! [ -f "$1" ] || ! [[ $1 == *.txt ]]; then
  echo " Please give a text file as unique argument "
  exit 1
fi


# Setup diretory for the generated split paragraphs from text                                       
if [ -e $UCCA_DIR/sentences/$article_name ]; then
    rm -f $UCCA_DIR/sentences/$article_name/*.txt
else
    mkdir $UCCA_DIR/sentences/$article_name/
fi

if [ -e $UCCA_DIR/passages/$article_name ]; then
    rm -f $UCCA_DIR/passages/$article_name/*.txt
else
    mkdir $UCCA_DIR/passages/$article_name/
fi

sentence_dir=$UCCA_DIR/sentences/$article_name
passage_dir=$UCCA_DIR/passages/$article_name

# Split text to paragraphs                                                                          
python $SCRIPTS/text_to_paragraphs.py $1
echo "---------------------- Text split to paragraphs"

# Parse the paragraphs                                                                              
python -m tupa $sentence_dir/*.txt -m $WORK_DIR/models/ucca-bilstm
mv *.xml $passage_dir
echo "---------------------- Parsed the paragraphs"


XML_DIR=$UCCA_DIR/passages/$article_name


# util now the first argument should be an XML file to split
# copy the spliting sentence into a text file
python $SCRIPTS/_1_Split_sentence.py $XML_DIR > $sentence_dir/Splitting.txt
cat $sentence_dir/Splitting.txt > $WORK_DIR/NeuralTextSimplification/data/test.en
cat $sentence_dir/Splitting.txt > $WORK_DIR/NeuralTextSimplification/data/test.sen
echo "---------------------- Splitting done"

# Pass sentences through the Neural Component
cd $WORK_DIR/NeuralTextSimplification/src/scripts/
source $WORK_DIR/NeuralTextSimplification/src/scripts/translate.sh
cd ../../results_NTS
echo "---------------------- Gone through the Neural Network"

value=$(<result_NTS_epoch11_10.19.t7_5)
echo "$value"

cd $WORK_DIR
#rm $XML_DIR/* # remove all XML files
