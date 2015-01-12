import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Main extends luxe.Game {
  var player : Sprite;
  var speed : Float = 128;
  var tileWidth = 32;

  override function ready() {
    var map = [
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
      name: 'the player',
      pos: new Vector(0 + tileWidth / 2, (10 * tileWidth) + tileWidth / 2),
      color: new Color().rgb(0xbada55),
      size: new Vector(tileWidth, tileWidth),
      depth: 2
    });

    drawMap(map);
    connectInput();
  }

  function drawMap(map : Array<Array<Int>>) {
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
  }

  override function update(delta:Float) {
    // the amazingness
    if (Luxe.input.inputdown('left')) {
      player.pos.x -= speed * delta;
    } else if (Luxe.input.inputdown('right')) {
      player.pos.x += speed * delta;
    }
  }

}
