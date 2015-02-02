import luxe.Camera;
import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;
import phoenix.Batcher;
import phoenix.geometry.TextGeometry;

class Hud {
  public var batcher : Batcher;
  public var text : TextGeometry;

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

  public function drawMap(map : Array<Array<MazeCell>>) {
    var rows = map.length,
        cols = map[0].length,
        width = 5 * cols,
        height = 5 * rows;

    Luxe.draw.box({
      x: Luxe.screen.w - width,
      y: 0,
      w: width,
      h: height,
      color: new Color(0,0,0,0.8).rgb(0xffffff),
      batcher: batcher
    });

    for (row in 0...rows) {
      for (col in 0...cols) {
        if (map[row][col] == MazeCell.wall) {
          Luxe.draw.box({
            x : Luxe.screen.w - width + col * 5,
            y : row * 5,
            w: 5,
            h: 5,
            color: new Color(0,0,0,1),
            batcher: batcher
          });
        }
      }
    }
  }
}