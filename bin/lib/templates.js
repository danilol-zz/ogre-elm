// Generate templates for different environments

// System
const fs = require('fs');
const path = require('path');

// Libs
const ejs = require('ejs');

// Globals
const rootPath = path.join(__dirname, '..', '..');

exports.configFile = function() {
  const confTemplatePath    = path.join(rootPath, 'config/application.js.ejs');
  const defConfTemplatePath = path.join(rootPath, 'config/reference.js.ejs');
  const confPath            = path.join(rootPath, 'src/config.js');

  var confTemplate;

  if (fs.existsSync(confTemplatePath)) {
    console.log(`Loading custom configuration file from ${confTemplatePath}`);

    confTemplate =
      fs.readFileSync(confTemplatePath, 'utf8');
  } else {
    console.log(`Loading default configuration file from ${defConfTemplatePath}`);

    confTemplate =
      fs.readFileSync(defConfTemplatePath, 'utf8');
  };

  const config = ejs.render(confTemplate, {env: process.env});

  fs.writeFile(confPath, config, function(err) {
    if(err) {
      return console.log(err);
    }

    console.log(`Configuration successfully loaded in: ${confPath}`);
  });
};

exports.indeHTMLFile = function(build) {
  const htmlTemplatePath = path.join(rootPath, 'config/index.html.ejs');
  const htmlPath =
    path.join(rootPath, `${build ? 'build' : 'src'}/index.html`);
  const htmlTemplate = fs.readFileSync(htmlTemplatePath, 'utf8');
  const html = ejs.render(htmlTemplate, {build: build});

  console.log(`Creating the html file`);

  if (!fs.existsSync(path.join(rootPath, 'build'))) {
    fs.mkdirSync(path.join(rootPath, 'build'));
  }

  fs.writeFile(htmlPath, html, function(err) {
    if(err) {
      return console.log(err);
    }

    console.log(`Created the html file in: ${htmlPath}`);
  });
}
