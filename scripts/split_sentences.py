#encoding: utf-8
from split_func import * # this module contains all functions details called here [look at: split_func.py] and other python libraries

##################################################################### 
#                     Load data & Variables:                       #
#####################################################################
#Global variables:       
# mypath directory xml files
mypath = sys.argv[1]
onlyXML = Get_XML_files(mypath) # get all XML file that outcome from parser part
layers = Get_Layers(mypath,onlyXML)

#####################################################################
#                              Main Operations:                     #
#####################################################################
# first we just work with the first xml file then we loop for others
layer = layers[0]
layer1, layer2 = layer[0], layer[1]
simple, Lists_Scene = Main(layer1, layer2) # Main function,  see details above

# This method is used to avoid problems with unicode characters encountered with print fucntion
sys.stdout.buffer.write ((simple + " \n").encode ('utf-8'))

for i in range(1,len(layers)):
    layer = layers[i]    
    layer1, layer2 = layer[0], layer[1]
    simple, Lists_Scene = Main(layer1, layer2) # Main function,  see details above
    if layer[2] == layers[i-1][2]:
        sys.stdout.buffer.write ((simple + " \n").encode ('utf-8'))
    elif layer[2] != layers[i-1][2]:
        sys.stdout.buffer.write (("\n" + simple + " \n").encode ('utf-8'))        