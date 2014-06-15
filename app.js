var path = require("path");
var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var width   = 200
var height  = 200
var backing = new Uint8ClampedArray(width*height)
var colors  = {}
app.use(express.static(path.join(__dirname, 'static')))

function setPixel(p, value) {
  var pixelLoc = p.x + (p.y * width)

  if (value) {
    colors[pixelLoc] = p.color;
  } else {
    delete colors[pixelLoc];
  }

  backing[pixelLoc] = value;
}

io.on('connection', function(socket){
  socket.emit('setup', {
    width: width,
    height: height,
    backing: backing,
    colors: colors,
    color: '#'+Math.floor(Math.random()*16777215).toString(16)
  });

  socket.on('addPixel', function(pixel){
    setPixel(pixel, 1);
    socket.broadcast.emit("addPixel", pixel);
  });

  socket.on('removePixel', function(pixel){
    setPixel(pixel, 0);
    socket.broadcast.emit("removePixel", pixel);
  });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});