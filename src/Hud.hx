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
}