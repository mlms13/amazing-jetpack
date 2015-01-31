import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import phoenix.Texture;
import luxe.tilemaps.Tilemap;
import MacroMaze;

class World {
  public var map : Array<Array<MazeCell>>;
  public var background : Sprite;
  public var rows : Int;
  public var cols : Int;
  public var tileSize : Int;
  public var startPos : Vector;
  public var endPos : Vector;

  var tileGrid : Array<Array<Int>>;
  var tiles : Tilemap;

  public function new(mapPath : String, ?tileSize = 32) {
    this.map = MacroMaze.load("src/maps/1.worldmap");
    tileGrid = [];
    this.tileSize = tileSize;
    this.rows = map.length;
    this.cols = map[0].length;

    var bgImage = Luxe.loadTexture('assets/background.png');
    bgImage.filter = FilterType.nearest;
    var height = Luxe.screen.h;
    var width = (height / bgImage.height) * bgImage.width;
    background = new Sprite({
      name: 'background',
      texture: bgImage,
      size: new Vector(width * 1.5, height * 1.5),
      centered: false
    });
  }

  public function draw() {
    for (row in 0...rows) {
      tileGrid[row] = [];
      for (col in 0...cols) {
        // creating a sprite for each tile is definitely not the right way
        getCell(map[row][col], row, col);
      }
    }
    tiles = new Tilemap({
      // location coords
      x: 0,
      y: 0,
      // width/height of map in tiles
      w: cols,
      h: rows,
      // size of the actual tiles in px
      tile_width: 128,
      tile_height: 128,
      // and finally, map orientation
      orientation: TilemapOrientation.ortho
    });

    tiles.add_tileset({
      name: 'tiles',
      texture: Luxe.loadTexture('assets/tiles.png'),
      tile_width: 128,
      tile_height: 128
    });

    tiles.add_layer({
      name: 'fg',
      layer: 1,
      opacity: 1,
      visible: true
    });

    tiles.add_tiles_from_grid('fg', tileGrid);

    tiles.display({
      scale: 1,
      batcher: null, // what is this? is `null` a problem?
      depth: 1
    });
  }

  function getCell(cell : MazeCell, row : Int, col : Int) switch cell {
    case open:
      tileGrid[row][col] = 0;
    case start:
      tileGrid[row][col] = 0;
      startPos = new Vector(col, row);
    case end:
      tileGrid[row][col] = 0;
      endPos = new Vector(col, row);
    case wall:
      tileGrid[row][col] = 1;
    case powerUp(value):
      tileGrid[row][col] = 0;
  }

  public function getValueAtTile(x : Float, y : Float) : MazeCell {
    var row = Math.floor(y / tileSize);
    var col = Math.floor(x / tileSize);

    // anything outside of the map is considered a wall
    if (row < 0 || row >= rows || col < 0 || col >= cols) {
      return MazeCell.wall;
    }
    return map[row][col];
  }
}
