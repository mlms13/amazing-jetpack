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
    // function to give us the real movement, based on map limits
    var movement = new Vector(0, 0);

    if (Luxe.input.inputdown('left')) {
      movement.x -= speed * delta;
    } else if (Luxe.input.inputdown('right')) {
      movement.x += speed * delta;
    } else if (Luxe.input.inputdown('up')) {
      movement.y -= speed * delta;
    } else if (Luxe.input.inputdown('down')) {
      movement.y += speed * delta;
    }

    if (movement.x > 0 || movement.y > 0) {
      movement = checkForCollision(player.pos, movement);
      player.pos.x += movement.x;
      player.pos.y += movement.y;
    }

  }

  function checkForCollision(current : Vector, movement : Vector) : Vector {
    // figure out of the tile at the target position is a block
    // and completely disable movement
    var target = new Vector(current.x + movement.x, current.y + movement.y);

    // when moving down or to the right, check the next block
    if (movement.x > 0 || movement.y > 0) {
      target.x = Math.ceil(target.x / tileWidth);
      target.y = Math.ceil(target.y / tileWidth);
    } else if (movement.x < 0 || movement.y < 0) {
      target.x = Math.floor(target.x / tileWidth);
      target.y = Math.floor(target.y / tileWidth);
    }

    if (mapTileIsSolid(Math.round(target.y), Math.round(target.x))) {
      movement.x = 0;
      movement.y = 0;
    }

    return movement;
  }

  function mapTileIsSolid(row, col) : Bool {
    return map[row][col] > 0;
  }

}
