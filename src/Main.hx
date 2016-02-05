import luxe.Text;
import luxe.Color;
import luxe.Input;
import luxe.Vector;

import phoenix.geometry.QuadGeometry;

class Main extends luxe.Game {
  public var grid     : Grid;

  public var mouse    : Vector;

  public var top      : Int = 50;
  public var right    : Int = 20;
  public var bottom   : Int = 20;
  public var left     : Int = 20;

  public var updated  : Float = 0.0;
  public var fps      : Int = 30;

  private var bg      : QuadGeometry;
  private var running : Bool = false;
  private var clicking: Bool = false;

  private var generation: Text;
  private var population: Text;

  override function config(config:luxe.AppConfig) {
    return config;
  } //config

  override function ready() {
    mouse = new Vector();

    var width = Luxe.screen.w - (left + right);
    var height = Luxe.screen.h - (top + bottom);

    bg = Luxe.draw.box({
        x : left, y : top,
        depth:-1,
        w : width,
        h : height,
        color : new Color().rgb(0x111111)
    });

    var rows = Math.floor(width / Cell.size);
    var cols = Math.floor(height / Cell.size);

    grid = new Grid(rows, cols);
    grid.offset(top, right, bottom, left);
    // grid.randomize();

    generation = new Text({
      no_scene : true,
      align : left,
      depth : 1,
      pos : new Vector(left, 5),
      point_size : 14.0,
      color: new Color().rgb(0xffffff)
    });

    population = new Text({
      no_scene : true,
      align : left,
      depth : 1,
      pos : new Vector(left, 25),
      point_size : 14.0,
      color: new Color().rgb(0xffffff)
    });
  }

  override function onmousemove( e:MouseEvent ) {
    mouse.set_xy(e.x, e.y);
  }

  override function onmousedown( e:MouseEvent ) {
    mouse.set_xy(e.x, e.y);
    clicking = true;
  }

  override function onmouseup( e:MouseEvent ) {
    mouse.set_xy(e.x, e.y);
    clicking = false;
  }

  override function onkeyup( e:KeyEvent ) {
    if(e.keycode == Key.escape) {
      Luxe.shutdown();
    } else if (e.keycode == Key.enter) {
      running = !running;
    } else if (e.keycode == Key.key_r) {
      grid.randomize();
    } else if (e.keycode == Key.key_c) {
      grid.clear();
    }
  } //onkeyup

  override function update(dt:Float) {
    updated += dt;

    generation.text = "Generation: " + grid.generation;
    population.text = "Population: " + grid.population();

    if (running && updated >= (1/fps)) {
        grid.iterate();
        updated = 0.0;
    } else if (clicking) {
      var x:Int = Math.floor((mouse.x-left) / Cell.size);
      var y:Int = Math.floor((mouse.y-top) / Cell.size);

      grid[x][y].live();
    }
  } //update
}

// import luxe.utils.Maths;
// import luxe.Rectangle;
// import luxe.Color;
// import luxe.Input;
// import luxe.Vector;
// import luxe.Text;
//
// import phoenix.geometry.QuadGeometry;
// import phoenix.geometry.RectangleGeometry;
//
// class Main extends luxe.Game {
//   public var bg       : QuadGeometry;
//   public var box      : QuadGeometry;
//   public var rect     : RectangleGeometry;
//   public var top      : Int = 0;
//   public var right    : Int = 0;
//   public var bottom   : Int = 0;
//   public var left     : Int = 0;
//   public var size     : Int = 10;
//   public var rows     : Int;
//   public var cols     : Int;
//   public var grid     : haxe.ds.Vector<haxe.ds.Vector<QuadGeometry>>;
//   public var white    : Color;
//   public var black    : Color;
//   public var mouse    : Vector;
//   public var clicking : Bool = false;
//   public var running  : Bool = false;
//   public var elapsed  : Float = 0.0;
//   public var updated  : Float = 0;
//   public var status   : Text;
//   public var width    : Int;
//   public var height   : Int;
//   public var fps      : Int = 30;
//   public var alive    : Array<Vector>;
//
//   override function config(config:luxe.AppConfig) {
//     return config;
//   } //config
//
//   override function ready() {
//     var g = new Grid(10, 10);
//
//     trace(g.get(0,0));
//
//     alive = new Array();
//     mouse = new Vector();
//     white = new Color().rgb(0xffffff);
//     black = new Color().rgb(0x000000);
//
//     width = Luxe.screen.w - (left + right);
//     height = Luxe.screen.h - (top + bottom);
//
//     rows = Math.floor(width / size);
//     cols = Math.floor(height / size);
//
//     grid = Vector2D.create(rows, cols);
//
//     bg = Luxe.draw.box({
//         x : left, y : top,
//         depth:-1,
//         w : width,
//         h : height,
//         color : black
//     });
//
//     // for (x in 0...rows) {
//       // for (y in 0...cols) {
//         // Luxe.draw.rectangle({
//         //     x : left + (x * size),
//         //     y : top + (y*size),
//         //     depth: 3,
//         //     w : size,
//         //     h : size,
//         //     color : new Color().rgb(0x00ff00)
//         // });
//
//         // var r:Float = Math.random();
//         //
//         // if (r > 0.90) {
//         //   make_alive(x,y);
//         // }
//     //   }
//     // }
//
//     // status = new Text({
//     //             no_scene : true,
//     //             text : 'Time: $elapsed',
//     //             align : left,
//     //             pos : new Vector(Math.floor(Luxe.screen.w / 2), 0),
//     //             point_size : 18.0,
//     //             color: new Color().rgb(0xcccccc)
//     //         });
//   } //ready
//
//   override function onkeyup( e:KeyEvent ) {
//     if(e.keycode == Key.escape) {
//       Luxe.shutdown();
//     } else if (e.keycode == Key.enter) {
//       running = !running;
//     }
//   } //onkeyup
//
  // override function onmousemove( e:MouseEvent ) {
  //   mouse.set_xy(e.x, e.y);
  //
  //   var x:Int = Math.floor(mouse.x / Cell.size);
  //   var y:Int = Math.floor(mouse.y / Cell.size);
  // }
//
//   override function onmousedown( e:MouseEvent ) {
//     mouse.set_xy(e.x, e.y);
//     clicking = true;
//   }
//
//   override function onmouseup( e:MouseEvent ) {
//     mouse.set_xy(e.x, e.y);
//     clicking = false;
//   }
//
//   override function update(dt:Float) {
//     elapsed += dt;
//     updated += dt;
//
//     if (running || clicking) {
//       var x:Int = Math.floor(mouse.x / size);
//       var y:Int = Math.floor(mouse.y / size);
//
//       if (!is_alive(x,y)) {
//         make_alive(x,y);
//       }
//     }
//
//     if (running) {
//       if (updated >= (1/fps)) {
//         var new_alive: Array<Vector> = new Array();
//
//         for (x in 0...rows) {
//           for (y in 0...cols) {
//             var num:Int = num_alive(x,y);
//
//             if (is_alive(x,y)) {
//               if (num < 2) {
//                 // make_dead(x,y);
//               } else if (num == 2 || num == 3) {
//                 new_alive.push(new Vector(x,y));
//                 // make_alive(x,y);
//               } else if (num > 3) {
//                 // make_dead(x,y);
//               }
//             } else {
//               if (num == 3) {
//                 new_alive.push(new Vector(x,y));
//                 // make_alive(x,y);
//               }
//             }
//           }
//         }
//
//         for (v in alive) {
//           make_dead(Math.floor(v.x), Math.floor(v.y));
//         }
//
//         for (v in new_alive) {
//           make_alive(Math.floor(v.x), Math.floor(v.y));
//         }
//
//         alive = new_alive;
//
//         updated = 0.0;
//       }
//     }
//
//
//   } //update
//
//   function make_alive(x:Int, y:Int) {
//     if (!is_alive(x,y)) {
//       if (grid[x][y] == null) {
//         grid[x][y] = Luxe.draw.box({
//           x: left + (x * size),
//           y: top + (y * size),
//           depth: 1,
//           w: size,
//           h: size,
//           color: white
//         });
//       } else {
//         grid[x][y].color = white;
//       }
//
//       alive.push(new Vector(x,y));
//     }
//   }
//
//   function make_dead(x:Int, y:Int) {
//     if (is_alive(x,y)) {
//       grid[x][y].color = black;
//     }
//   }
//
//   function is_alive(x:Int, y:Int) {
//     if (grid[x][y] != null) {
//       var c:Color = grid[x][y].color;
//
//       return (c.r == 1 && c.g == 1 && c.b == 1);
//     } else {
//       return false;
//     }
//   }
//
//   function num_alive(x:Int, y:Int) {
//     var num:Int = 0;
//
//     var min_x:Int = (x <= 0) ? 0 : x-1;
//     var max_x:Int = (x >= rows-1) ? rows-1 : x+1;
//     var min_y:Int = (y <= 0) ? 0 : y-1;
//     var max_y:Int = (y >= cols-1) ? cols-1 : y+1;
//
//     for (i in min_x...max_x+1) {
//       for (j in min_y...max_y+1) {
//         if (!(i == x && j == y)) {
//           if (is_alive(i, j)) {
//             num++;
//           }
//         }
//       }
//     }
//
//     return num;
//   }
// } //Main
