import luxe.Text;
import luxe.Input;
import luxe.Color;
import luxe.Vector;
import luxe.Sprite;

class MenuSprite extends Sprite implements MenuClickable {
  // public var fixed_size: Bool = false;
  // public var padding:Int = 25;
  public var text: Text;
  public var last_color: Color;
  public var text_size:Int = 20;
  public var color_hex:Int = 0x000000;

  public function new(options:MenuSpriteOptions) {
    options.centered = false;

    if (options.color == null) {
      options.color = new Color().rgb(0xffffff);
    }

    last_color = options.color;

    super(options);

    if (options.text != null) {
      set_text(options.text);
    }
  }

  public function set_text(str:String) {
    text = new Text({
      parent : this,
      text: str,
      align: TextAlign.center,
      align_vertical: TextAlign.center,
      depth : 10,
      pos : new Vector(size.x/2, size.y/2),
      point_size : text_size,
      color: new Color().rgb(color_hex)
    });

    // if (!fixed_size) {
    //   if (text.text_bounds.w > (max_x() - padding)) {
    //     size.x += (text.text_bounds.w - max_x());
    //     text.pos.x = pos.x + (size.x/2);
    //   }
    //
    //   if (text.text_bounds.h > (max_y() - padding)) {
    //     size.y += (text.text_bounds.h - max_y());
    //     text.pos.y = pos.y + (size.y/2);
    //   }
    // }
  }

  dynamic public function on_click() {
    // Global click handler for menu sprite(s)
  }

  override function onmousemove(e:MouseEvent) {
    if (in_bounds(e.pos)) {
      // last_color = color;
      color = new Color().rgb(0xcccccc);
    } else {
      color = last_color;
    }
  }

  override function onmousedown(e:MouseEvent) {
    if (in_bounds(e.pos)) on_click();
  }

  public function in_bounds(v:Vector) {
    return (v.x >= min_x() && v.x <= max_x() && v.y >= min_y() && v.y <= max_y());
  }

  public function min_x() {
    return pos.x;
  }

  public function max_x() {
    return min_x() + size.x;
  }

  public function min_y() {
    return pos.y;
  }

  public function max_y() {
    return min_y() + size.y;
  }
}
