import luxe.Camera;
import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;
import luxe.Sprite;
import phoenix.Batcher;
import phoenix.geometry.TextGeometry;

class Hud {
  var batcher : Batcher;
  var text : TextGeometry;
  var player : Sprite;
  var mapWidth : Int;
  var mapHeight : Int;
  var mapScale : Float;

  public function new() {
    batcher = Luxe.renderer.create_batcher({
      name: 'hud_batcher',
      layer: 4
    });

    Luxe.draw.box({
      x: 0,
      y: 0,
      w: Luxe.screen.w,
      h: 60,
      color: new Color(1, 1, 1, 0.8).rgb(0x665588),
      batcher: batcher
    });

    text = Luxe.draw.text({
      text: '0:00',
      point_size: 40,
      color : new Color().rgb(0xffffff),
      batcher: batcher
    });
  }

  public function setTime(time : Float) {
    var minutes = Math.floor(time / 60);
    var seconds = Math.floor(time % 60);
    var secondsPrefix = seconds < 10 ? "0" : "";
    text.text = Std.string(minutes) + ":" + secondsPrefix + Std.string(seconds);
  }

  public function drawMap(world : World) {
    var padding = 8;

    mapWidth = 5 * world.cols + (padding * 2);
    mapHeight = 5 * world.rows + (padding * 2);
    mapScale = 5 / world.tileSize;

    player = new Sprite({
      name: 'Mini Player',
      color: new Color().rgb(0x00aadd),
      pos: new Vector(0, 0),
      size: new Vector(5, 5),
      batcher: batcher,
      depth: 2
    });

    Luxe.draw.box({
      x: Luxe.screen.w - mapWidth,
      y: 60,
      w: mapWidth,
      h: mapHeight - 60,
      color: new Color(1, 1, 1, 0.8).rgb(0x665588),
      batcher: batcher
    });

    for (row in 0...world.rows) {
      for (col in 0...world.cols) {
        if (world.map[row][col] == MazeCell.wall) {
          Luxe.draw.box({
            x : Luxe.screen.w - mapWidth + (col * 5) + padding,
            y : (row * 5) + padding,
            w: 5,
            h: 5,
            color: new Color(0,0,0,75).rgb(0xffffff),
            batcher: batcher
          });
        }
      }
    }
  }

  public function positionPlayerInMap(pos : Vector) {
    var padding = 8;
    player.pos.x = Luxe.screen.w - mapWidth + padding + pos.x * mapScale;
    player.pos.y = padding + pos.y * mapScale;
  }
}