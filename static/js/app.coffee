canvas        = document.getElementById("app")
PIXEL         = 5
ctx           = null

socket.on "setup", ({width, height, backing, color, colors}) ->
  canvas.width  = width
  canvas.height = height

  ctx = canvas.getContext("2d")

  BOARD = new Board(canvas.width, canvas.height, backing, colors)

  USER = new User({
    board: BOARD,
    color: color
  })

class Board
  constructor: (@width, @height, backing, @colors) ->
    @backing = new Uint8ClampedArray(backing)

    @reDraw()
    socket.on("addPixel", ({x, y, color}) => @addPixel(x, y, true, color))
    socket.on("removePixel", ({x, y, color}) => @removePixel(x, y, true, color))

  reDraw: ->
    for i in [0...@backing.length]
      if (@backing[i])
        x     = (i) % @width
        y     = Math.floor((i) / @width)
        color = @colors[x + (y) * @width] or "#000"

        @addPixel(i % @width, Math.floor((i) / @width), true, color)

  getPixel: (x, y) ->
    p = x + (y * @width)

  removePixel: (x, y, silent=false) ->
    ctx.clearRect x * PIXEL, y * PIXEL, PIXEL, PIXEL
    @backing[@getPixel(arguments...)] = 0
    socket.emit("removePixel", {x: x, y: y}) unless silent

  addPixel: (x, y, silent=false, color="#000") ->
    ctx.fillStyle = color
    ctx.fillRect x * PIXEL, y * PIXEL, PIXEL, PIXEL
    @backing[@getPixel(arguments...)] = 1

    socket.emit("addPixel", {x: x, y: y, color: color}) unless silent

  isWithinBounds: (x, y) ->
    if x < 0 or y < 0 then return false
    if x * PIXEL + PIXEL > @width or y * PIXEL + PIXEL > @height then return false
    true

  isEmpty: (x, y) ->
    !@backing[@getPixel(arguments...)]

  isValid: (x, y) ->
    @isWithinBounds(arguments...) and @isEmpty(arguments...)

class User
  position: [0, 0]
  lastPosition: [0, 0]

  constructor: ({@board, @color}) ->
    @addListeners()
    @draw @positions...

  draw: ->
    @board.addPixel @position..., false, @color

  updatePosition: (x, y) ->
    @lastPosition = @position
    @position = [x, y]

  move: (x, y) ->
    return unless @board.isValid(x, y)

    @updatePosition arguments...
    @board.removePixel @lastPosition...
    @draw()

  moveUp    : -> @move @position[0], @position[1]-1
  moveDown  : -> @move @position[0], @position[1]+1
  moveLeft  : -> @move @position[0]-1, @position[1]
  moveRight : -> @move @position[0]+1, @position[1]

  dig       : ->
    return if @board.isEmpty(@position[0], @position[1]+1)

    @board.removePixel(@position[0], @position[1]+1)
    @fall()

  drop      : ->
    @board.addPixel @position[0], @position[1], false, @color
    @updatePosition @position[0], @position[1]-1
    @draw()

  fall: ->
    @moveDown() while @board.isValid(@position[0], @position[1]+1)

  addListeners: ->
    window.addEventListener "keydown", (e) =>
      switch e.keyCode
        when 39
          @moveRight()
        when 37
          @moveLeft()
        when 38
          @moveUp()
        when 40
          @moveDown()
        when 90
          @dig()
        when 88
          @drop()