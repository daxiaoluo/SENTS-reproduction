# State-of-the-art reproduction of SENTS

SENTS is a Neural Text Simplification system using Semantic Splitting for: 
[Simple and Effective Text Simplification Using Semantic and Neural Methods](http://www.aclweb.org/anthology/P18-1016)


## Requirements
- Python 3.6


## Simplify Text | Install & Configure

1. Checkout the repository
~~~bash
git clone https://github.com/nzaim001/Internship_2A.git
cd project_name
~~~

2. Create a Python virtual environment. For example, on Linux:
~~~bash
virtualenv --python=/usr/bin/python3 venv
venv/bin/activate
~~~

3. Install tupa & matplotlib
~~~bash
pip install tupa matplotlib
~~~

4. Download and unpack TUPA's pre-trained models
~~~bash
curl -LO https://github.com/huji-nlp/tupa/releases/download/v1.3.3/ucca-bilstm-1.3.3.tar.gz
tar xvzf ucca-bilstm-1.3.3.tar.gz
~~~

5. Checkout the NTS model repository
~~~bash
git clone --recursive https://github.com/senisioi/NeuralTextSimplification.git
The patch
~~~

6. OpenNMT dependencies (NTS)
	i. [Install Torch](http://torch.ch/docs/getting-started.html) (Using conda: [lua-torch](https://anaconda.org/alexbw/lua-torch))
	ii. Install additional packages:
	~~~bash
	luarocks install tds
	~~~

7. Help on commands to run the system using the Makefile
~~~bash
make help
~~~


## The Content of this Repository

####./scripts
- **article_to_sentences.py**: A small script that splits the given article to many files, each one containing a single sentence. 
- **split_sentences.py**: A script that uses two semantic rules to split sentences presented in a UCCA-parsed XML format. 

####./website
* A web server to run the Text Simplification system
 

## Authors 
* Hamza Ezzarouali El Boudri: hapaa@hotmail.fr
* Nabil Zaim: 


## Credit & Acknoweldgement
* M. Olivier Augereau
* M. Kise Koichi
* IMP
* Osaka Prefecture University
* ENSEIRB-MATMECA | Bordeaux INP