import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Main extends luxe.Game {
  var player : Sprite;
  var speed : Float = 128;

  override function ready() {
    // do something here when assets have finished loading...
    player = new Sprite({
      name: 'the player',
      pos: Luxe.screen.mid,
      color: new Color().rgb(0xbada55),
      size: new Vector(128, 128)
    });

    connectInput();
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
    player.rotation_z += 40 * delta;

    if (Luxe.input.inputdown('left')) {
      player.pos.x -= speed * delta;
    } else if (Luxe.input.inputdown('right')) {
      player.pos.x += speed * delta;
    }
  }

}
