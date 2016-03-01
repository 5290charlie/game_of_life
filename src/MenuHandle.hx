import luxe.Color;

class MenuHandle extends MenuSprite {
  public var menu_active: Bool = false;

  public function toggle() {
    menu_active = !menu_active;

    if (menu_active) {
      last_color = color = new Color().rgb(0x333333);
      text.color = new Color().rgb(0xffffff);
    } else {
      last_color = color = new Color().rgb(0xffffff);
      text.color = new Color().rgb(0x000000);
    }
  }
}
