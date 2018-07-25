
# coding: utf-8

import sys, os


filename, extension = os.path.splitext (sys.argv[1])
article_name = filename.split ("/") [-1]
paragraph_path = "./scripts/paragraphs/" + article_name


# Read the text file

with open ( filename + extension, "r") as textfile:
    text = textfile.read ()
    textfile.close()


# Split text to paragraphs
paragraphs = text.split ("\n\n")
paragraphs[-1] = paragraphs[-1].strip()

# Put each paragraph in a file inside the article folder (must be precreated)

for i in range (len(paragraphs)):
    p_filename = paragraph_path + "/" + article_name + "_" + str (i+1) + ".txt"

    p_file = open (p_filename, 'w')
    p_file.write (paragraphs[i])
    p_file.close()

