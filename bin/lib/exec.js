// Execute a command in a child process

// System
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

exports.exec = function(name, bin, argv) {
  const process = spawn(bin, argv);
  const processLog = function(data) { console.log(`${name}: ${data}`) };
  console.log(bin + ' ' + argv)

  process.stdout.on('data', (data) => { processLog(data) });
  process.stderr.on('data', (data) => { processLog(data) });
  process.on('close', (code) => {
    console.log(`${name}: exited with code ${code}`);
  });
};
