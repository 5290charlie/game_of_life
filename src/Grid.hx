class Grid implements ArrayAccess<Array<Cell>> {
  public var rows       : Int;
  public var cols       : Int;

  public var top        : Int = 0;
  public var right      : Int = 0;
  public var bottom     : Int = 0;
  public var left       : Int = 0;
  public var generation : Int = 0;

  public var active     : Bool = true;

  public var alive      : Array<Cell>;

#if cpp
  public var cells: Array<Array<Cell>>;
#end

  public function new(w:Int, h:Int) {
#if cpp
    this.cells = new Array();
#end

    alive = new Array();

    rows = w;
    cols = h;

    for (i in 0...w) {
      var row:Array<Cell> = new Array();

      for (j in 0...h) {
        row.push(new Cell(i, j, this));
      }

      this.__set(i, row);
    }
  }

  public function offset(t:Int, r:Int, b:Int, l:Int) {
    offset_top(t);
    offset_right(r);
    offset_bottom(b);
    offset_left(l);
  }

  public function offset_top(t:Int) {
    top = t;
  }

  public function offset_right(r:Int) {
    right = r;
  }

  public function offset_bottom(b:Int) {
    bottom = b;
  }

  public function offset_left(l:Int) {
    left = l;
  }

  public function iterate() {
    generation++;
    var new_alive: Array<Cell> = new Array();

    for (x in 0...rows) {
      for (y in 0...cols) {
        var cell = this[x][y];

        var num:Int = cell.alive_neighbors();

        if (cell.alive && (num == 2 || num == 3)) {
          new_alive.push(cell);
        } else if (!cell.alive && num == 3) {
          new_alive.push(cell);
        }
      }
    }

    if (alive.length == new_alive.length) {
      active = false;
    } else {
      active = true;
    }

    for (c in alive) {
      c.die();
    }

    for (c in new_alive) {
      c.live();
    }

    if (new_alive.length > 0) {
      alive = new_alive;
    } else {
      active = false;
    }
  }

  public function clear() {
    for (c in alive) {
      c.die();
    }
  }

  public function population() {
    return alive.length;
  }

  public function randomize() {
    clear();
    
    for (x in 0...rows) {
      for (y in 0...cols) {
        var r:Float = Math.random();

        if (r > 0.90) {
          this[x][y].live();
        }
      }
    }
  }

  @:arrayAccess
  public inline function __get(k:Int) {
#if cpp
    return this.cells[k];
#else
    return this[k];
#end
  }

  @:arrayAccess
  public inline function __set(k:Int, v:Array<Cell>):Array<Cell> {
#if cpp
    return this.cells[k] = v;
#else
    return this[k] = v;
#end
  }
}
