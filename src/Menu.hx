import luxe.Vector;
import luxe.tween.Actuate;

class Menu {
  public var anchor: Vector;
  public var bounds: Vector;
  public var handle: MenuHandle;
  public var items: Array<MenuItem>;
  public var depth: Int = 2;
  public var item_size: Int = 50;

  public function new(name:String, a:Vector, b:Vector) {
    items = new Array();

    anchor = a;
    bounds = b;

    handle = new MenuHandle({
      size: new Vector(100, 40),
      pos: anchor,
      depth: depth+1,
      text: name
    });

    handle.on_click = toggle.bind();
  }

  public function add(str:String, func:Dynamic) {
    var item = new MenuItem({
      size: new Vector(bounds.x, item_size),
      pos: new Vector(anchor.x, anchor.y + handle.size.y + (items.length * item_size)),
      depth: depth+1,
      text: str
    });

    item.size.y = 0;
    item.text.visible = false;

    item.on_click = func;

    items.push(item);
  }

  public function toggle() {
    handle.toggle();

    for (i in items) {
      Actuate.tween(i.size, 0.5, {y: (i.size.y > 0) ? 0 : item_size}).ease(luxe.tween.easing.Cubic.easeInOut).onComplete(function() {i.text.visible=!i.text.visible;});
    }
  }

  public function is_active() {
    return handle.menu_active;
  }
}
