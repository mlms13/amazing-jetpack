import luxe.Input;
import luxe.Sprite;
import luxe.Vector;

class Main extends luxe.Game {
  public var world : World;
  var player : Player;
  var acceleration : Float;
  var tileSize = 32;
  var playerSize = 24;

  override function config(config:luxe.AppConfig) {
    config.window.width = tileSize * 32;
    config.window.height = tileSize * 24;
    return config;
  }

  override function ready() {
    acceleration = 0.9;
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

    Luxe.input.bind_key('jump', Key.space);

    Luxe.input.bind_key('up', Key.up);
    Luxe.input.bind_key('up', Key.key_w);
  }

  override function update(delta : Float) {
    // start by attempting to apply gravity
    player.velocity.y = Math.min(player.velocity.y + 0.2, 8);

    // however, if the player is on the ground, allow them to jump
    if (Luxe.input.inputdown('jump') && player.isOnGround) {
      player.velocity.y = -player.jumpSpeed * delta;
    }

    // and even if they aren't on the ground, they can always use the jetpack
    // TODO: ...if it has fuel
    if (Luxe.input.inputdown('up')) {
      player.velocity.y -= (player.maxSpeed / 4) * delta;
      player.velocity.y = Math.max(player.velocity.y, -4);
    }

    if (Luxe.input.inputdown('left')) {
      player.velocity.x = -player.maxSpeed * delta;
    }
    if (Luxe.input.inputdown('right')) {
      player.velocity.x = player.maxSpeed * delta;
    }
    player.move(world);
  }
}
