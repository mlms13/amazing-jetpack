import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Main extends luxe.Game {
  var player : Sprite;
  var speed : Float = 0;

  override function ready() {
    // do something here when assets have finished loading...
    player = new Sprite({
      name: 'the player',
      pos: Luxe.screen.mid,
      color: new Color().rgb(0xbada55),
      size: new Vector(128, 128)
    });
  }

  override function update(delta:Float) {
    // the amazingness
    player.rotation_z += 40 * delta;
  }

}
