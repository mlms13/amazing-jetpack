import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Player {
  public var rendering : Sprite;
  public var isOnGround : Bool;
  public var velocity : Vector;
  public var maxSpeed : Float = 128;
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

  public function moveX(howFar : Float, world : World) {
    if (howFar > 0) {
      rendering.pos.x = avoidRightCollision(rendering.pos.x + howFar, world);
    } else {
      rendering.pos.x = avoidLeftCollision(rendering.pos.x + howFar, world);
    }
  }
  public function moveY(howFar : Float, world : World) {
    if (howFar > 0) {
      rendering.pos.y = avoidBottomCollision(rendering.pos.y + howFar, world);
    } else {
      rendering.pos.y = avoidTopCollision(rendering.pos.y + howFar, world);
    }
  }

  function avoidLeftCollision(targetX : Float, world : World) : Float {
    if (mapTileIsSolid(world, targetX, rendering.pos.y) ||
        mapTileIsSolid(world, targetX, rendering.pos.y + (size - 1))) {
      targetX = Math.ceil(targetX / world.tileSize) * world.tileSize;
    }
    return targetX;
  }

  function avoidRightCollision(targetX : Float, world : World) : Float {
    if (mapTileIsSolid(world, targetX + (size -1), rendering.pos.y) ||
        mapTileIsSolid(world, targetX + (size - 1), rendering.pos.y + (size - 1))) {
      targetX = Math.floor(targetX / world.tileSize) * world.tileSize + (world.tileSize - size);
    }
    return targetX;
  }

  function avoidBottomCollision(targetY : Float, world : World) : Float {
    if (mapTileIsSolid(world, rendering.pos.x, targetY + (size - 1)) ||
        mapTileIsSolid(world, rendering.pos.x + (size - 1), targetY + (size - 1))) {
      targetY = Math.floor(targetY / world.tileSize) * world.tileSize + (world.tileSize - size);
    }
    return targetY;
  }

  function avoidTopCollision(targetY : Float, world : World) : Float {
    if (mapTileIsSolid(world, rendering.pos.x, targetY) ||
        mapTileIsSolid(world, rendering.pos.x + (size - 1), targetY)) {
      targetY = Math.ceil(targetY / world.tileSize) * world.tileSize;
    }
    return targetY;
  }

  function mapTileIsSolid(world : World, x : Float, y : Float) : Bool {
    return switch world.getValueAtTile(x, y) {
      case MazeCell.wall: true;
      case _: false;
    };
  }
}
