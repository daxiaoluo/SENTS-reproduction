var express = require("express");
var app = express(); // init App;
var expressValidator = require('express-validator');
var bodyParser = require('body-parser');
var fs = require('fs');
var uploadFile = require('express-fileupload');
var formidable = require('formidable');
var parseurl = require('parseurl');
var cookieParser = require('cookie-parser');
const path = require('path')
const shell = require('shelljs');
app.use(cookieParser());
app.use(expressValidator());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

var output =""
////////////////////////////////////////////////
app.get('/',function(req, res){
  res.sendFile(__dirname + '/page.html');
});
////////////////////////////////////////////////
app.get('/ts',function(req, res){
  res.json(output)
  output =""
});
//////////////////////////////////////////////////////
app.post('/ts', function(req,res){
  fs.writeFile(__dirname + '/input.txt',req.body.texte ,'utf8', function (err) {
    if (err) throw err;
    shell.exec(path.join(__dirname, '../.webserver_run.sh ')+ path.join(__dirname, '/input.txt'));
    fs.readFile(__dirname + '/input-simple.txt', 'utf8', function(err, contents) {
      output = contents;
    });
    res.redirect('/');
  });
});
//////////////////////////////////////////////////////
app.post('/fileupload', function(req,res){
  var form = new formidable.IncomingForm();
  form.parse(req, function (err, fields, files) {
    var oldpath = files.filetoupload.path;
    var newpath = __dirname + '/' + files.filetoupload.name;
    fs.rename(oldpath, newpath, function (err) {
      if (err) throw err;
      //shell.exec(path.join(__dirname, '../.webserver_run.sh ')+ path.join(newpath)); // execute the entire model
      fs.readFile(__dirname + '/' + files.filetoupload.name.split(".")[0]+'-simple.txt', 'utf8', function(err, contents) {
        output = contents;
      });
      res.redirect('/');
    });
  });
});
////////////////////////////////////////////////
app.listen(3000, () => console.log('Server is running. Copy this url on your browser: localhost:3000/'))
