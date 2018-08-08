
# encoding: utf-8

import sys, os


filename, extension = os.path.splitext (sys.argv[1])
article_name = filename.split ("/") [-1]
sentence_path = "./scripts/sentences/" + article_name


# Read the text file

with open ( filename + extension, "r", encoding="utf-8") as textfile:
    text = textfile.read ()
    textfile.close()


# Split text to sentences
paragraphs = text.split ("\n\n")
paragraphs[-1] = paragraphs[-1].strip()


# Put each sentence in a file inside the article folder (must be precreated)
for i in range (len (paragraphs)): # i for paragraphs
    for j in range(len (paragraphs[i].split ('.')) - 1): # j for sentences in each paragraph        
        s_filename = sentence_path + "/" + article_name + "_" + str(i+1) + "_" + str(j+1) + ".txt"

        s_file = open (s_filename, 'w', encoding="utf-8")
        s_file.write (paragraphs[i].split('.')[j] + '.')
        s_file.close()

