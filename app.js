var path = require("path");
var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.use(express.static(path.join(__dirname, 'static')))

io.on('connection', function(socket){
  console.log('a user connected');

  socket.on('addPixel', function(pixel){
    socket.broadcast.emit("addPixel", pixel);
  });

  socket.on('removePixel', function(pixel){
    socket.broadcast.emit("removePixel", pixel);
  });

});

http.listen(3000, function(){
  console.log('listening on *:3000');
});