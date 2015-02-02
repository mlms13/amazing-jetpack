import luxe.Sprite;
import luxe.Color;
import luxe.Text;

class VisualOverlay {
  var background : Sprite;
  var text : Text;

  public function new() {
    background = new Sprite({
      name: 'overlay',
      centered: false,
      size: Luxe.screen.size,
      color: new Color(255, 255, 255, 0),
      depth: 4
    });

    // load font resource
    text = new Text({
      point_size: 64,
      depth: 4.1,
      align: TextAlign.center,
      text: 'Default Message',
      font: Luxe.resources.find_font('norwester'),
      color: new Color(0, 0, 0, 0).rgb(0xffffff)
    });
  }

  public function setMessage(msg : String) {
    text.text = msg;
  }

  public function show() {
    background.pos = Luxe.camera.pos;
    text.pos = Luxe.camera.center;
    text.pos.y -= Luxe.screen.h / 4;
    background.color.tween(.5, {a: 0.7});
    Luxe.timer.schedule(.5, function () {
      text.color.tween(.5, {a: 1});
    });
  }
}