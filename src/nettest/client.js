var net = require('net');
// For the input stream
var readline = require('readline');
var rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout
});

var HOST = 'localhost';
var PORT = 8080;

var client = new net.Socket();
client.connect(PORT, HOST, function() {
	console.log('Connected to: ' + HOST + ':' + PORT);
});

// Emitted whenever the input stream receives a \n
rl.on('line', function (cmd) {
	// Write a message to the socket
	client.write(cmd);
	console.log("I said: "+cmd);
});

// Add a 'data' event handler for the client socket
// data is what the server sent to this socket
client.on('data', function(data) {
	console.log('DATA: ' + data);
	// Close the client socket completely
	client.destroy();
});

// Add a 'close' event handler for the client socket
client.on('close', function() {
	console.log('Connection closed');
});