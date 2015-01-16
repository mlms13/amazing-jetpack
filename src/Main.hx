import luxe.Input;
import luxe.Sprite;
import luxe.Vector;

class Main extends luxe.Game {
  public var world : World;
  var player : Player;
  var speed : Float = 128;
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

  override function update(delta:Float) {
    // Figure out our attempted keyboard movement, but ask our collision
    // functions to give us the real movement, based on map limits
    var movement = new Vector(0, 0);

    if (Luxe.input.inputdown('left')) {
      player.rendering.pos.x = limitLeftCollision(player.rendering.pos.x - (speed * delta));
    }

    if (Luxe.input.inputdown('right')) {
      player.rendering.pos.x = limitRightCollision(player.rendering.pos.x + (speed * delta));
    }

    if (Luxe.input.inputdown('up')) {
      player.rendering.pos.y = limitTopCollision(player.rendering.pos.y - (speed * delta));
    }

    if (Luxe.input.inputdown('down')) {
      player.rendering.pos.y = limitBottomCollision(player.rendering.pos.y + (speed * delta));
    }
  }

  function limitBottomCollision(targetY : Float) : Float {
    // check both bottom corners for collisions
    if (mapTileIsSolid(player.rendering.pos.x, targetY + (playerSize - 1)) ||
        mapTileIsSolid(player.rendering.pos.x + (playerSize - 1), targetY + (playerSize - 1))) {
      targetY = Math.floor(targetY / tileSize) * tileSize + (tileSize - playerSize);
    }
    return targetY;
  }

  function limitTopCollision(targetY : Float) : Float {
    if (mapTileIsSolid(player.rendering.pos.x, targetY) ||
        mapTileIsSolid(player.rendering.pos.x + (playerSize - 1), targetY)) {
      targetY = Math.ceil(targetY / tileSize) * tileSize;
    }
    return targetY;
  }

  function limitLeftCollision(targetX : Float) : Float {
    if (mapTileIsSolid(targetX, player.rendering.pos.y) ||
        mapTileIsSolid(targetX, player.rendering.pos.y + (playerSize - 1))) {
      targetX = Math.ceil(targetX / tileSize) * tileSize;
    }
    return targetX;
  }

  function limitRightCollision(targetX : Float) : Float {
    if (mapTileIsSolid(targetX + (playerSize - 1), player.rendering.pos.y) ||
        mapTileIsSolid(targetX + (playerSize - 1), player.rendering.pos.y + (playerSize - 1))) {
      targetX = Math.floor(targetX / tileSize) * tileSize + (tileSize - playerSize);
    }
    return targetX;
  }

  function mapTileIsSolid(x : Float, y : Float) : Bool {
    return switch world.getValueAtTile(x, y) {
      case MazeCell.wall: true;
      case _: false;
    };
  }
}
