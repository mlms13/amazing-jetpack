import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Player {
  public var rendering : Sprite;
  public var isOnGround : Bool;
  public var currentWorld : World;
  public var velocity : Vector;
  public var maxSpeed : Float;
  public var jumpSpeed : Float;
  public var size : Vector;

  public function new(startPos : Vector, size : Vector, world : World) {
    isOnGround = true;
    currentWorld = world;
    velocity = new Vector(0, 0);
    maxSpeed = 2 * currentWorld.tileSize;
    jumpSpeed = 4 * currentWorld.tileSize;
    this.size = size;

    rendering = new Sprite({
      centered: false,
      name: 'The Player',
      texture: Luxe.loadTexture('assets/penguin.png'),
      pos: new Vector(startPos.x, startPos.y + currentWorld.tileSize - size.y),
      size: size,
      depth: 2
    });
  }

  public function isCollidingWith(pos : Vector, h : Float, w : Float) {
    var xCollision = (rendering.pos.x > pos.x && rendering.pos.x < pos.x + w) ||
                     (rendering.pos.x + size.x > pos.x && rendering.pos.x + size.x < pos.x + w),
        yCollision = (rendering.pos.y > pos.y && rendering.pos.y < pos.y + h) ||
                     (rendering.pos.y + size.y > pos.y && rendering.pos.y + size.y < pos.y + h);

    return xCollision && yCollision;
  }

  public function move() {
    if (velocity.x != 0) {
      moveX();
    }
    if (velocity.y != 0) {
      isOnGround = false;
      moveY();
    }
  }

  public function moveX() {
    if (velocity.x > 0) {
      rendering.pos.x = avoidRightCollision(rendering.pos.x + velocity.x);
    } else {
      rendering.pos.x = avoidLeftCollision(rendering.pos.x + velocity.x);
    }
    // reset horizontal motion each time we update it
    velocity.x = 0;
  }
  public function moveY() {
    if (velocity.y > 0) {
      rendering.pos.y = avoidBottomCollision(rendering.pos.y + velocity.y);
    } else {
      rendering.pos.y = avoidTopCollision(rendering.pos.y + velocity.y);
    }
  }

  function avoidLeftCollision(targetX : Float) : Float {
    if (mapTileIsSolid(targetX, rendering.pos.y) ||
        mapTileIsSolid(targetX, rendering.pos.y + (size.y - 1))) {
      targetX = Math.ceil(targetX / currentWorld.tileSize) * currentWorld.tileSize;
    }
    return targetX;
  }

  function avoidRightCollision(targetX : Float) : Float {
    if (mapTileIsSolid(targetX + size.x, rendering.pos.y) ||
        mapTileIsSolid(targetX + size.x, rendering.pos.y + (size.y - 1))) {
      targetX = Math.floor(targetX / currentWorld.tileSize) * currentWorld.tileSize + (currentWorld.tileSize - size.x);
    }
    return targetX;
  }

  function avoidBottomCollision(targetY : Float) : Float {
    if (mapTileIsSolid(rendering.pos.x, targetY + size.y) ||
        mapTileIsSolid(rendering.pos.x + (size.x - 1), targetY + size.y)) {
      velocity.y = 0;
      isOnGround = true;
      targetY = Math.floor(targetY / currentWorld.tileSize) * currentWorld.tileSize + (currentWorld.tileSize - size.y);
    }
    return targetY;
  }

  function avoidTopCollision(targetY : Float) : Float {
    if (mapTileIsSolid(rendering.pos.x, targetY) ||
        mapTileIsSolid(rendering.pos.x + (size.x - 1), targetY)) {
      velocity.y = 0;
      targetY = Math.ceil(targetY / currentWorld.tileSize) * currentWorld.tileSize;
    }
    return targetY;
  }

  function mapTileIsSolid(x : Float, y : Float) : Bool {
    return switch currentWorld.getValueAtTile(x, y) {
      case MazeCell.wall: true;
      case _: false;
    };
  }
}
