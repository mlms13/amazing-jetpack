import luxe.Input;
import luxe.Sprite;
import luxe.Vector;

class Main extends luxe.Game {
  public var world : World;
  var player : Player;
  var acceleration : Float;
  var tileSize = 128;
  var playerSize = 48;

  override function config(config:luxe.AppConfig) {
    config.window.width = 800;
    config.window.height = 600;
    return config;
  }

  override function ready() {
    acceleration = 0.9;
    world = new World(tileSize);
    player = new Player(new Vector(0, 18 * tileSize + (tileSize - playerSize)), playerSize, world);

    Luxe.camera.zoom = 1;

    world.draw();
    connectInput();
  }

  override function onmousewheel( e:MouseEvent ) {
    if(e.y < 0 && Luxe.camera.zoom < 1) {
      // wheel_up
      Luxe.camera.zoom += 0.1;
    } else if(e.y > 0) {
      // wheel_down
      Luxe.camera.zoom -= 0.1;
    }
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
    player.velocity.y = Math.min(player.velocity.y + 0.25, 12);

    // however, if the player is on the ground, allow them to jump
    if (Luxe.input.inputdown('jump') && player.isOnGround) {
      player.velocity.y = -player.jumpSpeed * delta;
    }

    // and even if they aren't on the ground, they can always use the jetpack
    // TODO: ...if it has fuel
    if (Luxe.input.inputdown('up')) {
      player.velocity.y -= (player.maxSpeed / 4) * delta;
      player.velocity.y = Math.max(player.velocity.y, -6);
    }

    if (Luxe.input.inputdown('left')) {
      player.velocity.x = -player.maxSpeed * delta;
    }
    if (Luxe.input.inputdown('right')) {
      player.velocity.x = player.maxSpeed * delta;
    }
    player.move();
    Luxe.camera.center = new Vector(player.rendering.pos.x, player.rendering.pos.y);
  }
}
