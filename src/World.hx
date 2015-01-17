import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import MacroMaze;

class World {
  public var map : Array<Array<MazeCell>>;
  public var rows : Int;
  public var cols : Int;
  public var tileSize : Int;

  public function new(?mapPath : String, ?tileSize = 32) {
    // eventually a map path won't be optional, and we'll read
    // a json file here to create the map. for now...
    this.map = MacroMaze.load("src/maps/1.worldmap");
    this.tileSize = tileSize;
    this.rows = map.length;
    this.cols = map[0].length;
  }

  public function draw() {
    for (row in 0...rows) {
      for (col in 0...cols) {
        // creating a sprite for each tile is definitely not the right way
        drawCell(map[row][col], row, col);
      }
    }
  }

  function drawCell(cell : MazeCell, row : Int, col : Int) switch cell {
    case open:
      new Sprite({
        centered: false,
        pos: new Vector(col * tileSize, row * tileSize),
        color: new Color().rgb(0xffffff),
        size: new Vector(tileSize, tileSize)
      });
    case wall:
      new Sprite({
        centered: false,
        pos: new Vector(col * tileSize, row * tileSize),
        color: new Color().rgb(0x0),
        size: new Vector(tileSize, tileSize)
      });
    case powerUp(value):
      // do something more interesting
      new Sprite({
        centered: false,
        pos: new Vector(col * tileSize, row * tileSize),
        color: new Color().rgb(0xffffff),
        size: new Vector(tileSize, tileSize)
      });
  }

   public function getValueAtTile(x : Float, y : Float) : MazeCell {
     return map[Math.floor(y / tileSize)][Math.floor(x / tileSize)];
   }
}
