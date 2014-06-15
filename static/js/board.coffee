class window.Board
  constructor: (@width, @height, @ctx, @pixel, backing, @colors) ->
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
    @ctx.clearRect x * @pixel, y * @pixel, @pixel, @pixel
    @backing[@getPixel(arguments...)] = 0

    socket.emit("removePixel", {x: x, y: y}) unless silent

  addPixel: (x, y, silent=false, color="#000") ->
    @ctx.fillStyle = color
    @ctx.fillRect x * @pixel, y * @pixel, @pixel, @pixel
    @backing[@getPixel(arguments...)] = 1

    socket.emit("addPixel", {x: x, y: y, color: color}) unless silent

  isWithinBounds: (x, y) ->
    if x < 0 or y < 0 then return false
    if x * @pixel + @pixel > @width or y * @pixel + @pixel > @height then return false
    true

  isEmpty: (x, y) ->
    !@backing[@getPixel(arguments...)]

  isValid: (x, y) ->
    @isWithinBounds(arguments...) and @isEmpty(arguments...)
