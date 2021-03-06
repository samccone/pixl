// Generated by CoffeeScript 1.6.3
(function() {
  var PIXEL, canvas, ctx;

  canvas = document.getElementById("app");

  PIXEL = 2;

  ctx = null;

  socket.on("setup", function(_arg) {
    var BOARD, USER, backing, color, colors, height, width;
    width = _arg.width, height = _arg.height, backing = _arg.backing, color = _arg.color, colors = _arg.colors;
    canvas.width = width;
    canvas.height = height;
    BOARD = new Board(canvas.width, canvas.height, canvas.getContext("2d"), PIXEL, backing, colors);
    return USER = new User({
      board: BOARD,
      color: color
    });
  });

}).call(this);
