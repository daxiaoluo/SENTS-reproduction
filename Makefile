# -------TO_DO
# Merge & send to github
# More features to add
#	Split makefile into small ones
# 	many files to simplify in the same call
#	Simple call for make without file="file_name"
#	Cleaning before remake
#	OS compatibility
#	(still the case when it only fails partially -> to be treated)


# State-of-the-art paper: http://www.aclweb.org/anthology/P18-1016


SHELL := /bin/bash
NC := \033[0m #No color
RED := \033[0;31m
GREEN := \033[0;32m

work_dir=$(PWD)
script_dir=$(work_dir)/scripts
NTS_dir=$(work_dir)/NeuralTextSimplification_model

file?=""
filetype:=$(shell file $(file) | cut -d: -f2)

article_name = $(basename $(notdir $(file)))
article_simple = $(article_name)-simple.txt
NTS_script = $(NTS_dir)/src/scripts/translate.sh
NTS_input = $(NTS_dir)/data/test.en
NTS_result_file = $(NTS_dir)/results_NTS/result_NTS_epoch11_10.19.t7_5

# passage = xml file representing a sentence parsed with TUPA
sentence_dir = $(script_dir)/sentences/$(article_name)
passage_dir = $(script_dir)/passages/$(article_name)
sentences = $(sentence_dir)/*.txt
passages = $(passage_dir)/*.xml


############################################################################################

.SILENT:
.ONESHELL: # To execute all commands in one single bash shell
.PHONY: all file_test NTS DSS tupa_parse split_to_sentences clean


# Precleans in order to avoid any conflicts with previous simplifications
all: file_test $(article_simple)
	printf "\n${GREEN}Article simplified :\n====================${NC}\n\n"
	cat $(article_simple)


# evaluate the system results using BLUE & SARI metrics
# The original test.en must be given to evaluate (https://github.com/senisioi/NeuralTextSimplification)
evaluate: all
	printf "\n${GREEN}Evaluating: (the original test.en must be given)${NC}\n\n"
	python $(NTS_dir)/src/evaluate.py $(NTS_input) $(NTS_dir)/data/references/references.tsv $(NTS_dir)/predictions


############################################################################################

# The following targets are only useful as aliases for testing

# Generates the NTS model result file after making the following targets.
NTS: file_test $(NTS_result_file)

# Generates the article sentences split using the two semantic rules mentioned in the paper.
DSS: file_test $(NTS_input)

# Parses the article's sentences using TUPA -> output : xml files
tupa_parse: file_test $(passages)

# Splits the article into sentences, each one in a single file
split_to_sentences: file_test $(sentences)


#############################################################################################


# Testing the validity of the file
file_test:
# 	Whether the file was provided as an argument
	if [ $(file) = "" ]; then 
		printf "${RED}ERROR${NC}: One & only file must be given in argument! Please specify it by:\nmake file=<file_name> <target>\n\n"; exit 1
	fi

# 	Whether the file exists 
	if [ ! -f $(file) ]; then
		printf "$(RED)ERROR${NC}: $(file) File not found!\n\n"; exit 1
	fi

#	Whether the file is empty
	if [ ! -s $(file) ]; then
		printf "$(RED)ERROR${NC}: $(file) is empty!\n\n"; exit 1
	fi

# 	Whether it is a text file 
	if [[ "$(filetype)" != " ASCII text" && "$(filetype)" != " UTF-8 Unicode text" ]]; then
		printf "$(RED)ERROR${NC}: Only text files (ASCII or UTF-8 Unicode text) are accepted!\n\n"; exit 1
	fi

##############################################################################################


$(article_simple): $(NTS_result_file)
	cd $(work_dir)
	cat $(NTS_result_file) > $(article_simple)


$(NTS_result_file): $(NTS_script) $(NTS_input)
	printf "\n${GREEN}Simplifying sentences using the NTS model ... :${NC}\n\n"
	cd $(NTS_dir)/src/scripts/
	source ./translate.sh


$(NTS_input): $(script_dir)/split_sentences.py $(passages)	
	printf "\n${GREEN}Splitting the article's sentences : ... ${NC}\n"
	python $(script_dir)/split_sentences.py $(passage_dir) > $(NTS_input)

#	If the output of the splitting is empty, then it failed
	if [ ! -s $(NTS_input) ]; then
		printf "$(RED)ERROR${NC}: Splitting failed!\n\n"; exit 1
	fi


$(passages): $(sentences) | $(passage_dir) 
	printf "\n${GREEN}Parsing the article's sentences : ... ${NC}\n\n"
	python -m tupa $(sentences) -m $(work_dir)/TUPA_models/ucca-bilstm
	mv *.xml $(passage_dir)


$(sentences): $(file) $(script_dir)/article_to_sentences.py | $(sentence_dir)
	python $(script_dir)/article_to_sentences.py $(file)


# Creates the passage directory
$(passage_dir): $(file)
	if [ -d $(passage_dir) ]; then 
		rm -f $(passage_dir)/*.xml
	else
		mkdir -p $(script_dir)/passages/
		mkdir $(passage_dir)/
	fi


# Creates the sentence directory
$(sentence_dir): $(file)
	if [ -d $(sentence_dir) ]; then
		rm -f $(sentence_dir)/*.txt
	else
	    	mkdir -p $(script_dir)/sentences/
		mkdir $(sentence_dir)
	fi


clean:
	rm -rf $(passage_dir)* $(sentence_dir)*
	echo > $(NTS_result_file)
