# This script installs the modules needed to run the web server

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install npm --global
npm init
npm install --save angular

npm i express-validator
npm i fs
npm i formidable
npm i parseurl
npm i path
npm i shelljs
npm i express
npm i body-parser
npm i express-fileupload
