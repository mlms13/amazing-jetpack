import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Player {
  public var rendering : Sprite;
  public var isOnGround : Bool;
  public var velocity : Vector;
  public var size : Int;

  public function new(startPos : Vector, ?size = 24) {
    this.size = size;
    isOnGround = true;
    velocity = new Vector(0, 0);
    rendering = new Sprite({
      centered: false,
      name: 'The Player',
      pos: startPos,
      color: new Color().rgb(0xbada55),
      size: new Vector(size, size),
      depth: 2
    });
  }
}
