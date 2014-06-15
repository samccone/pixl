canvas        = document.getElementById("app")
PIXEL         = 2
ctx           = null

socket.on "setup", ({width, height, backing, color, colors}) ->
  canvas.width  = width
  canvas.height = height

  BOARD = new Board(
    canvas.width,
    canvas.height,
    canvas.getContext("2d"),
    PIXEL,
    backing,
    colors
  )

  USER = new User({
    board: BOARD,
    color: color
  })
