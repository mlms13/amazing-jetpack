import luxe.Input;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Parcel;
import luxe.ParcelProgress;

class Main extends luxe.Game {
  public var world : World;
  var player : Player;
  var acceleration : Float;
  var tileSize = 128;
  var playerSize = 48;

  override function config(config:luxe.AppConfig) {
    config.window.width = 800;
    config.window.height = 600;
    return config;
  }

  override function ready() {
    acceleration = 0.9;

    var assets = Luxe.loadJSON('assets/parcel.json');
    var preload = new Parcel();
    preload.from_json(assets.json);

    new ParcelProgress({
      parcel: preload,
      background: new Color(1, 1, 1, 0.85),
      oncomplete: onAssetsLoaded
    });

    preload.load();
  }

  function onAssetsLoaded(_) {
    world = new World(tileSize);
    player = new Player(new Vector(0, 18 * tileSize + (tileSize - playerSize)), playerSize, world);
    world.draw();
    connectInput();
  }

  function connectInput() {
    // wire up the keyboard
    Luxe.input.bind_key('left', Key.left);
    Luxe.input.bind_key('left', Key.key_a);

    Luxe.input.bind_key('right', Key.right);
    Luxe.input.bind_key('right', Key.key_d);

    Luxe.input.bind_key('jump', Key.space);

    Luxe.input.bind_key('up', Key.up);
    Luxe.input.bind_key('up', Key.key_w);
  }

  override function update(delta : Float) {
    if (player == null) {
        return;
    }
    // start by attempting to apply gravity
    player.velocity.y = Math.min(player.velocity.y + 0.25, 12);

    // however, if the player is on the ground, allow them to jump
    if (Luxe.input.inputdown('jump') && player.isOnGround) {
      player.velocity.y = -player.jumpSpeed * delta;
    }

    // and even if they aren't on the ground, they can always use the jetpack
    // TODO: ...if it has fuel
    if (Luxe.input.inputdown('up')) {
      player.velocity.y -= (player.maxSpeed / 4) * delta;
      player.velocity.y = Math.max(player.velocity.y, -6);
    }

    if (Luxe.input.inputdown('left')) {
      player.velocity.x = -player.maxSpeed * delta;
    }
    if (Luxe.input.inputdown('right')) {
      player.velocity.x = player.maxSpeed * delta;
    }
    player.move();
    positionCamera();
    positionBackground();
  }

  function positionCamera() {
    // handle camera position, by default x and y are centered on the player
    var cameraX = player.rendering.pos.x + (playerSize / 2) - (Luxe.screen.w / 2),
        cameraY = player.rendering.pos.y + (playerSize / 2) - (Luxe.screen.h / 2),
        leftEdge = 0,
        rightEdge = world.cols * world.tileSize,
        topEdge = 0,
        bottomEdge = world.rows * world.tileSize;

    // Camera must be bound to the four edges
    cameraX = Math.max(cameraX, leftEdge);
    cameraX = Math.min(cameraX, rightEdge - Luxe.screen.w);

    cameraY = Math.max(cameraY, topEdge);
    cameraY = Math.min(cameraY, bottomEdge - Luxe.screen.h);

    // change the camera position
    Luxe.camera.pos.x = cameraX;
    Luxe.camera.pos.y = cameraY;
  }

  function positionBackground() {
    // track how far the camera has moved as a percent of how far it could move
    var mapPxWidth = world.cols * tileSize,
        mapPxHeight = world.rows * tileSize,
        cameraRangeX = mapPxWidth - Luxe.screen.w,
        cameraRangeY = mapPxHeight - Luxe.screen.h,
        bgRangeX = mapPxWidth - world.background.size.x,
        bgRangeY = mapPxHeight - world.background.size.y;

    world.background.pos.x = (Luxe.camera.pos.x / cameraRangeX) * bgRangeX;
    world.background.pos.y = (Luxe.camera.pos.y / cameraRangeY) * bgRangeY;
  }
}
