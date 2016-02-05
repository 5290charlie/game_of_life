import luxe.Color;
import luxe.Vector;

import phoenix.geometry.QuadGeometry;

class Cell {
  public static var size : Int = 10;

  public var box   : QuadGeometry;
  public var pos   : Vector;
  public var alive : Bool = false;

  public var red   : Color;
  public var green : Color;
  public var white : Color;
  public var black : Color;

  private var grid : Grid;

  public function new(x:Int, y:Int, g:Grid) {
    red = new Color().rgb(0xff0000);
    green = new Color().rgb(0x00ff00);
    white = new Color().rgb(0xffffff);
    black = new Color().rgb(0x000000);

    pos = new Vector(x,y);
    grid = g;
  }

  public function draw() {
    var start : Color;
    var finish : Color;

    start = (alive) ? green : red;

    if (box == null) {
      box = Luxe.draw.box({
        x: grid.left + (pos.x * size),
        y: grid.top + (pos.y * size),
        depth: -1,
        w: size,
        h: size
      });
    }

    box.color.set(start.r, start.g, start.b);

    if (alive) {
      finish = white;
    } else {
      finish = black;
    }

    box.color.tween(1, {r: finish.r, g: finish.g, b: finish.b});
  }

  public function set_alive(a:Bool) {
    alive = a;
    draw();
  }

  public function die() {
    if (alive) {
      set_alive(false);
    }
  }

  public function live() {
    if (!alive) {
      set_alive(true);
      grid.alive.push(this);
    }
  }

  public function alive_neighbors() {
    var num:Int = 0;

    var x = Math.floor(pos.x);
    var y = Math.floor(pos.y);

    var rows = grid.rows;
    var cols = grid.cols;

    var min_x:Int = (x <= 0) ? 0 : x-1;
    var max_x:Int = (x >= rows-1) ? rows-1 : x+1;
    var min_y:Int = (y <= 0) ? 0 : y-1;
    var max_y:Int = (y >= cols-1) ? cols-1 : y+1;

    for (i in min_x...max_x+1) {
      for (j in min_y...max_y+1) {
        if (!(i == x && j == y) && grid[i][j].alive) num++;
      }
    }

    return num;
  }
}
