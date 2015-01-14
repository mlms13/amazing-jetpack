import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class World {
  public var map : Array<Array<Int>>;
  public var rows : Int;
  public var cols : Int;
  public var tileSize : Int;

  public function new(?mapPath : String, ?tileSize = 32) {
    // eventually a map path won't be optional, and we'll read
    // a json file here to create the map. for now...
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
    this.tileSize = tileSize;
    this.rows = map.length;
    this.cols = map[0].length;
  }

  public function draw() {
    for (row in 0...rows) {
      for (cell in 0...cols) {
        // creating a sprite for each tile is definitely not the right way
        new Sprite({
          centered: false,
          pos: new Vector(cell * tileSize, row * tileSize),
          color: (map[row][cell] == 1) ? new Color().rgb(0x0) : new Color().rgb(0xffffff),
          size: new Vector(tileSize, tileSize)
        });
      }
    }
  }

  public function getValueAtTile(x : Float, y : Float) : Int {
    return map[Math.floor(y / tileSize)][Math.floor(x / tileSize)];
  }
}
