var path = require("path");
var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var width   = 50
var height  = 50
var backing = new Uint8ClampedArray(width*height)

app.use(express.static(path.join(__dirname, 'static')))

function setPixel(x, y, value) {
  backing[x + (y * width)] = value;
}

io.on('connection', function(socket){
  console.log('a user connected');
  socket.emit('setup', {width: width, height: height, backing: backing});

  socket.on('addPixel', function(pixel){
    setPixel(pixel.x, pixel.y, 1);
    socket.broadcast.emit("addPixel", pixel);
  });

  socket.on('removePixel', function(pixel){
    setPixel(pixel.x, pixel.y, 0);
    socket.broadcast.emit("removePixel", pixel);
  });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});