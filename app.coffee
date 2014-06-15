path    = require('path')
express = require('express')
app     = express()
http    = require('http').Server(app)
io      = require('socket.io')(http);

width   = 200
height  = 200
backing = new Uint8ClampedArray(width * height)
colors  = {}

app.use express.static path.join __dirname, 'static'

setPixel = (p, value) ->
  pixelLoc = p.x + (p.y * width)

  if value
    colors[pixelLoc] = p.color
  else
    delete colors[pixelLoc]

  backing[pixelLoc] = value

io.on 'connection', (socket) ->
  socket.emit 'setup',
    width   : width,
    height  : height,
    backing : backing,
    colors  : colors,
    color   : "##{Math.floor(Math.random() * 16777215).toString(16)}"

  socket.on 'addPixel', (pixel) ->
    setPixel pixel, 1
    socket.broadcast.emit 'addPixel', pixel

  socket.on 'removePixel', (pixel) ->
    setPixel pixel, 0
    socket.broadcast.emit 'removePixel', pixel

http.listen 3000, -> console.log 'listening on *:3000'
