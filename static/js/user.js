// Generated by CoffeeScript 1.6.3
(function() {
  var __slice = [].slice;

  window.User = (function() {
    User.prototype.position = [0, 0];

    User.prototype.lastPosition = [0, 0];

    function User(_arg) {
      this.board = _arg.board, this.color = _arg.color;
      this.addListeners();
      this.fall();
      this.draw.apply(this, this.positions);
    }

    User.prototype.draw = function() {
      var _ref;
      (_ref = this.board).addPixel.apply(_ref, __slice.call(this.position).concat([false], [this.color]));
      return this;
    };

    User.prototype.updatePosition = function(x, y) {
      this.lastPosition = this.position;
      this.position = [x, y];
      return this;
    };

    User.prototype.move = function(x, y) {
      var _ref;
      if (!this.board.isValid(x, y)) {
        return;
      }
      this.updatePosition.apply(this, arguments);
      (_ref = this.board).removePixel.apply(_ref, this.lastPosition);
      return this.draw();
    };

    User.prototype.moveUp = function() {
      var newPos;
      newPos = [this.position[0], this.position[1] - 1];
      if (this.canMoveUp()) {
        this.board.removePixel.apply(this.board, newPos);
        return this.move.apply(this, newPos);
      }
    };

    User.prototype.moveDown = function() {
      var newPos;
      newPos = [this.position[0], this.position[1] + 1];
      if (!this.board.isEmpty.apply(this.board, newPos) && this.board.isWithinBounds.apply(this.board, newPos)) {
        this.board.removePixel.apply(this.board, newPos);
      }
      return this.move.apply(this, newPos).fall();
    };

    User.prototype.moveLeft = function() {
      var newPos;
      newPos = [this.position[0] - 1, this.position[1]];
      if (!this.board.isEmpty.apply(this.board, newPos) && this.board.isWithinBounds.apply(this.board, newPos)) {
        this.board.removePixel.apply(this.board, newPos);
      }
      return this.move.apply(this, newPos).fall();
    };

    User.prototype.moveRight = function() {
      var newPos;
      newPos = [this.position[0] + 1, this.position[1]];
      if (!this.board.isEmpty.apply(this.board, newPos) && this.board.isWithinBounds.apply(this.board, newPos)) {
        this.board.removePixel.apply(this.board, newPos);
      }
      return this.move.apply(this, newPos).fall();
    };

    User.prototype.canMoveUp = function() {
      return (!this.board.isEmpty(this.position[0], this.position[1] - 1) || !this.board.isEmpty(this.position[0] - 1, this.position[1] - 1) || !this.board.isEmpty(this.position[0] + 1, this.position[1] - 1) || !this.board.isEmpty(this.position[0] - 1, this.position[1]) || !this.board.isEmpty(this.position[0] + 1, this.position[1])) || (!this.board.isWithinBounds(this.position[0] - 1, this.position[1]) || !this.board.isWithinBounds(this.position[0] + 1, this.position[1]));
    };

    User.prototype.drop = function() {
      if (!this.board.isValid(this.position[0], this.position[1] - 1)) {
        return;
      }
      this.board.addPixel(this.position[0], this.position[1], false, this.color);
      return this.updatePosition(this.position[0], this.position[1] - 1).draw();
    };

    User.prototype.fall = function() {
      var _results;
      _results = [];
      while (!this.canMoveUp() && this.board.isValid(this.position[0], this.position[1] + 1)) {
        _results.push(this.moveDown());
      }
      return _results;
    };

    User.prototype.addListeners = function() {
      var _this = this;
      return window.addEventListener("keydown", function(e) {
        switch (e.keyCode) {
          case 39:
            return _this.moveRight();
          case 37:
            return _this.moveLeft();
          case 38:
            return _this.moveUp();
          case 40:
            return _this.moveDown();
          case 88:
            return _this.drop();
        }
      });
    };

    return User;

  })();

}).call(this);
