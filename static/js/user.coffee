class window.User
  position: [0, 0]
  lastPosition: [0, 0]

  constructor: ({@board, @color}) ->
    @addListeners()
    @fall()
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

  moveUp    : ->
    newPos = [@position[0], @position[1]-1]

    if (@canMoveUp())
      @board.removePixel.apply(@board, newPos)
      @move.apply(@, newPos)

  moveDown  : ->
    newPos = [@position[0], @position[1]+1]

    if (!@board.isEmpty.apply(@board, newPos) and @board.isWithinBounds.apply(@board, newPos))
      @board.removePixel.apply(@board, newPos)

    @move.apply(@, newPos)
    @fall()

  moveLeft  : ->
    newPos = [@position[0]-1, @position[1]]

    if (!@board.isEmpty.apply(@board, newPos) and @board.isWithinBounds.apply(@board, newPos))
      @board.removePixel.apply(@board, newPos)

    @move.apply(@, newPos) and @fall()

  moveRight : ->
    newPos = [@position[0]+1, @position[1]]

    if (!@board.isEmpty.apply(@board, newPos) and @board.isWithinBounds.apply(@board, newPos))
      @board.removePixel.apply(@board, newPos)

    @move.apply(@, newPos) and @fall()

  canMoveUp: ->
    # top or top left, or top right or
    # left or right occupied
    (
      !@board.isEmpty(@position[0],   @position[1]-1) or
      !@board.isEmpty(@position[0]-1, @position[1]-1) or
      !@board.isEmpty(@position[0]+1, @position[1]-1) or
      !@board.isEmpty(@position[0]-1, @position[1])   or
      !@board.isEmpty(@position[0]+1, @position[1])
    ) or
    # at the left or right of board
    (
      !@board.isWithinBounds(@position[0]-1, @position[1]) or
      !@board.isWithinBounds(@position[0]+1, @position[1])
    )

  drop      : ->
    return unless @board.isValid(@position[0], @position[1]-1)

    @board.addPixel @position[0], @position[1], false, @color
    @updatePosition @position[0], @position[1]-1
    @draw()

  fall: ->
    @moveDown() while !@canMoveUp() and @board.isValid(@position[0], @position[1]+1)

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
        when 88
          @drop()