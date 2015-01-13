import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Main extends luxe.Game {
  var player : Sprite;
  var map : Array<Array<Int>>;
  var speed : Float = 128;
  var tileSize = 32;
  var playerSize = 24;

  override function ready() {
    map = [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ];

    // do something here when assets have finished loading...
    player = new Sprite({
      centered: false,
      name: 'the player',
      pos: new Vector(0, 10 * tileSize + (tileSize - playerSize)),
      color: new Color().rgb(0xbada55),
      size: new Vector(playerSize, playerSize),
      depth: 2
    });

    drawMap();
    connectInput();
  }

  function drawMap() {
    for (row in 0...map.length) {
      for (cell in 0...map[row].length) {
        new Sprite({
          centered: false,
          pos: new Vector(cell * tileSize, row * tileSize),
          color: (map[row][cell] == 1) ? new Color().rgb(0x0) : new Color().rgb(0xffffff),
          size: new Vector(tileSize, tileSize)
        });
      }
    }
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
      player.pos.x = limitLeftCollision(player.pos.x - (speed * delta));
    } else if (Luxe.input.inputdown('right')) {
      player.pos.x = limitRightCollision(player.pos.x + (speed * delta));
    } else if (Luxe.input.inputdown('up')) {
      player.pos.y = limitTopCollision(player.pos.y - (speed * delta));
    } else if (Luxe.input.inputdown('down')) {
      player.pos.y = limitBottomCollision(player.pos.y + (speed * delta));
    }
  }

  function limitBottomCollision(targetY : Float) : Float {
    // check both bottom corners for collisions
    if (mapTileIsSolid(player.pos.x, targetY + (playerSize - 1)) ||
        mapTileIsSolid(player.pos.x + (playerSize - 1), targetY + (playerSize - 1))) {
      targetY = Math.floor(targetY / tileSize) * tileSize + (tileSize - playerSize);
    }
    return targetY;
  }

  function limitTopCollision(targetY : Float) : Float {
    if (mapTileIsSolid(player.pos.x, targetY) ||
        mapTileIsSolid(player.pos.x + (playerSize - 1), targetY)) {
      targetY = Math.ceil(targetY / tileSize) * tileSize;
    }
    return targetY;
  }

  function limitLeftCollision(targetX : Float) : Float {
    if (mapTileIsSolid(targetX, player.pos.y) ||
        mapTileIsSolid(targetX, player.pos.y + (playerSize - 1))) {
      targetX = Math.ceil(targetX / tileSize) * tileSize;
    }
    return targetX;
  }

  function limitRightCollision(targetX : Float) : Float {
    if (mapTileIsSolid(targetX + (playerSize - 1), player.pos.y) ||
        mapTileIsSolid(targetX + (playerSize - 1), player.pos.y + (playerSize - 1))) {
      targetX = Math.floor(targetX / tileSize) * tileSize + (tileSize - playerSize);
    }
    return targetX;
  }

  function mapTileIsSolid(x : Float, y : Float) : Bool {
    return map[Math.floor(y / tileSize)][Math.floor(x / tileSize)] > 0;
  }
}
