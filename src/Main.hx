import luxe.Text;
import luxe.Color;
import luxe.Input;
import luxe.Vector;
import luxe.utils.Maths;

import phoenix.geometry.QuadGeometry;

class Main extends luxe.Game {
  public var grid     : Grid;

  public var mouse    : Vector;

  public var top      : Int = 50;
  public var right    : Int = 20;
  public var bottom   : Int = 20;
  public var left     : Int = 20;

  public var updated  : Float = 0.0;
  public var fps      : Int = 5;
  public var text_pt  : Float = 14.0;

  private var bg      : QuadGeometry;
  private var running : Bool = false;
  private var clicking: Bool = false;

  private var generation: Text;
  private var population: Text;

  private var menu:Menu;

  override function config(config:luxe.AppConfig) {
    return config;
  } //config

  override function ready() {
#if mobile
    top = 100;
    text_pt = 40.0;
    Cell.size = 20;
#end

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

    generation = new Text({
      no_scene : true,
      align : center,
      depth : 1,
      pos : new Vector(Luxe.screen.w/2, (text_pt/3)),
      point_size : text_pt,
      color: new Color().rgb(0xffffff)
    });

    population = new Text({
      no_scene : true,
      align : center,
      depth : 1,
      pos : new Vector(Luxe.screen.w/2, (text_pt/3)+text_pt),
      point_size : text_pt,
      color: new Color().rgb(0xffffff)
    });

    menu = new Menu('Controls', new Vector(left, 0), new Vector(200, 200));

    menu.add('Start/Stop (enter)', function() {
      running = !running;
      menu.toggle();
    });

    menu.add('Randomize (r)', function() {
      grid.randomize();
      running = true;
      menu.toggle();
    });

    menu.add('Clear (c)', function() {
      grid.clear();
      running = false;
      menu.toggle();
    });

    menu.add('Exit (esc)', function() {
      Luxe.shutdown();
    });
  }

  public function faster() {
    fps++;
    Maths.clampi(fps, 1, 60);
  }

  public function slower() {
    fps--;
    Maths.clampi(fps, 1, 60);
  }

  override function onmousemove( e:MouseEvent ) {
    mouse.set_xy(e.x, e.y);
  }

  override function onmousedown( e:MouseEvent ) {
    mouse.set_xyz(e.x, e.y, e.button);
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
    } else if (e.keycode == Key.key_f) {
      faster();
    } else if (e.keycode == Key.key_s) {
      slower();
    }
  } //onkeyup

  override function update(dt:Float) {
    updated += dt;

    generation.text = "Generation: " + grid.generation;
    population.text = "Population: " + grid.population();

    if (running && updated >= (1/fps)) {
        grid.iterate();
        updated = 0.0;
    } else if (clicking && !menu.is_active()) {
      var x:Int = Math.floor((mouse.x-left) / Cell.size);
      var y:Int = Math.floor((mouse.y-top) / Cell.size);

      if (grid[x] != null && grid[x][y] != null) {
        if (mouse.z == MouseButton.left) {
          grid[x][y].live();
        } else if (mouse.z == MouseButton.right) {
          grid[x][y].die();
        }
      }
    }
  } //update
}
