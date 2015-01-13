import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Main extends luxe.Game {
  var player : Sprite;
  var map : Array<Array<Int>>;
  var speed : Float = 128;
  var tileWidth = 32;

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
      pos: new Vector(0, 10 * tileWidth),
      color: new Color().rgb(0xbada55),
      size: new Vector(tileWidth, tileWidth),
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
          pos: new Vector(cell * tileWidth, row * tileWidth),
          color: (map[row][cell] == 1) ? new Color().rgb(0x0) : new Color().rgb(0xffffff),
          size: new Vector(tileWidth, tileWidth)
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
    if (mapTileIsSolid(player.pos.x, targetY + (tileWidth - 1)) ||
        mapTileIsSolid(player.pos.x + (tileWidth - 1), targetY + (tileWidth - 1))) {
      targetY = Math.floor(targetY / tileWidth) * tileWidth;
      trace("COLLISION DOWN: returning a new target y coord of " + targetY);
    }
    return targetY;
  }

  function limitTopCollision(targetY : Float) : Float {
    if (mapTileIsSolid(player.pos.x, targetY) ||
        mapTileIsSolid(player.pos.x + (tileWidth - 1), targetY)) {
      targetY = Math.ceil(targetY / tileWidth) * tileWidth;
      trace("COLLISION UP: returning a new target y coord of " + targetY);
    }
    return targetY;
  }

  function limitLeftCollision(targetX : Float) : Float {
    if (mapTileIsSolid(targetX, player.pos.y) ||
        mapTileIsSolid(targetX, player.pos.y + (tileWidth - 1))) {
      targetX = Math.ceil(targetX / tileWidth) * tileWidth;
    }
    return targetX;
  }

  function limitRightCollision(targetX : Float) : Float {
    if (mapTileIsSolid(targetX + (tileWidth - 1), player.pos.y) ||
        mapTileIsSolid(targetX + (tileWidth - 1), player.pos.y + (tileWidth - 1))) {
      targetX = Math.floor(targetX / tileWidth) * tileWidth;
    }
    return targetX;
  }

  function mapTileIsSolid(x : Float, y : Float) : Bool {
    return map[Math.floor(y / tileWidth)][Math.floor(x / tileWidth)] > 0;
  }
}
