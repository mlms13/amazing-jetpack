import luxe.Input;
import luxe.Sprite;
import luxe.Vector;

class Main extends luxe.Game {
  public var world : World;
  var player : Player;
  var tileSize = 32;
  var playerSize = 24;

  override function config(config:luxe.AppConfig) {
    config.window.width = tileSize * 32;
    config.window.height = tileSize * 24;
    return config;
  }

  override function ready() {
    world = new World(tileSize);
    player = new Player(new Vector(0, 18 * tileSize + (tileSize - playerSize)), playerSize);

    world.draw();
    connectInput();
  }

  function connectInput() {
    // wire up the keyboard
    Luxe.input.bind_key('left', Key.left);
    Luxe.input.bind_key('left', Key.key_a);

    Luxe.input.bind_key('right', Key.right);
    Luxe.input.bind_key('right', Key.key_d);

    Luxe.input.bind_key('up', Key.up);
    Luxe.input.bind_key('up', Key.key_w);

    Luxe.input.bind_key('down', Key.down);
    Luxe.input.bind_key('down', Key.key_s);
  }

  override function update(delta : Float) {
    // Figure out our attempted keyboard movement, but ask our collision
    // functions to give us the real movement, based on map limits
    if (Luxe.input.inputdown('left')) {
      player.moveX(-1 * player.maxSpeed * delta, world);
    }

    if (Luxe.input.inputdown('right')) {
      player.moveX(player.maxSpeed * delta, world);
    }

    if (Luxe.input.inputdown('up')) {
      player.moveY(-1 * player.maxSpeed * delta, world);
    }

    if (Luxe.input.inputdown('down')) {
      player.moveY(player.maxSpeed * delta, world);
    }
  }
}
