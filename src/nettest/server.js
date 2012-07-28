var net = require('net');
var HOST = 'localhost';
var PORT = 8080;
var currentID = 0;

var server = net.createServer(function (socket) {
	// We have a connection - a socketet object is assigned to the connection automatically
	socket.ID = ++currentID;
	console.log('Incoming connection from client: ' + socket.remoteAddress +':'+ socket.remotePort+', ID: '+socket.ID);
	//console.log(socket);
	// Add a 'data' event handler to this instance of socketet
	socket.on('data', function(data) {
		console.log('Incoming message from: '+socket.ID);
		console.log('"' + data + '" ('+data.length+')');
		// Write the data back to the socketet, the client will receive it as data from the server
		//socket.write('"' + data + '" ('+data.size+')');
	});
	// Add a 'close' event handler to this instance of socketet
	socket.on('close', function(data) {
		console.log('Client '+socket.ID+' disconnected!');
	});
});
server.listen(PORT, HOST);

console.log('Server listening on ' + HOST +':'+ PORT+' waiting for clients!');