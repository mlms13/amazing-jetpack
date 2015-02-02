import luxe.Input;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Parcel;
import luxe.ParcelProgress;

class Main extends luxe.Game {
  var level : Level;
  var overlay : VisualOverlay;
  var hud : Hud;
  var player : Player;
  var acceleration : Float;
  var tileSize = 128;
  var playerSize = new Vector(43, 64);

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
    hud = new Hud();
    overlay = new VisualOverlay();
    level = new Level("src/maps/1.worldmap", tileSize);
    player = new Player(level.world.startPos, playerSize, level.world);
    player.createAnimation();
    hud.drawMap(level.world);
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
    if (player == null || level == null || !level.isActive) {
        return;
    }
    var moving = false;

    // start by attempting to apply gravity
    player.velocity.y = Math.min(player.velocity.y + 0.25, 12);

    // however, if the player is on the ground, allow them to jump
    if (Luxe.input.inputdown('jump') && player.isOnGround) {
      player.velocity.y = -player.jumpSpeed * delta;
      moving = true;
      if (player.anim.animation != 'jump') {
        player.anim.animation = 'jump';
      }
    }

    // and even if they aren't on the ground, they can always use the jetpack
    // ...if it has fuel
    if (Luxe.input.inputdown('up')) {
      if (player.currentFuel > player.fuelBurnRate * delta) {
        player.currentFuel = Math.max(0, player.currentFuel - player.fuelBurnRate * delta);
        player.velocity.y -= (player.maxSpeed / 4) * delta;
        player.velocity.y = Math.max(player.velocity.y, -6);
        moving = true;
        if (player.anim.animation != 'jetpack') {
          player.anim.animation = 'jetpack';
        }
      } else if (player.anim.animation != 'fuelless') {
        player.anim.animation = 'fuelless';
      }
    } else {
      // fuel recharges because of magic
      player.currentFuel = Math.min(player.maxFuel, player.currentFuel + player.fuelChargeRate * delta);
    }

    if (Luxe.input.inputdown('left')) {
      player.velocity.x = -player.maxSpeed * delta;
      player.rendering.flipx = true;
      if (player.isOnGround) {
        moving = true;
        if (player.anim.animation != 'walk') {
          player.anim.animation = 'walk';
        }
      }
    }
    if (Luxe.input.inputdown('right')) {
      player.velocity.x = player.maxSpeed * delta;
      player.rendering.flipx = false;
      if (player.isOnGround) {
        moving = true;
        if (player.anim.animation != 'walk') {
          player.anim.animation = 'walk';
        }
      }
    }

    if (!moving && (player.isOnGround || (player.anim.animation != 'jump' && player.anim.animation != 'fuelless'))) {
      player.anim.animation = 'idle';
    }


    if (player.velocity.x != 0 || player.velocity.y != 0) {
      positionCamera();
      positionBackground();
      player.move();
    }
    level.time += delta;
    hud.setTime(level.time);
    hud.positionPlayerInMap(player.rendering.pos);
    hud.updateFuelMeter(player.currentFuel, player.maxFuel);

    // figure out if player is in the "end" tile
    if (player.isCollidingWith(level.world.endPos, tileSize, tileSize)) {
      level.isActive = false;
      overlay.setMessage('you win!');
      overlay.show();
    }
  }

  function positionCamera() {
    // handle camera position, by default x and y are centered on the player
    var cameraX = player.rendering.pos.x + (playerSize.x / 2) - (Luxe.screen.w / 2),
        cameraY = player.rendering.pos.y + (playerSize.y / 2) - (Luxe.screen.h / 2),
        leftEdge = 0,
        rightEdge = level.world.cols * level.world.tileSize,
        topEdge = 0,
        bottomEdge = level.world.rows * level.world.tileSize;

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
    var mapPxWidth = level.world.cols * tileSize,
        mapPxHeight = level.world.rows * tileSize,
        cameraRangeX = mapPxWidth - Luxe.screen.w,
        cameraRangeY = mapPxHeight - Luxe.screen.h,
        bgRangeX = mapPxWidth - level.world.background.size.x,
        bgRangeY = mapPxHeight - level.world.background.size.y;

    level.world.background.pos.x = (Luxe.camera.pos.x / cameraRangeX) * bgRangeX;
    level.world.background.pos.y = (Luxe.camera.pos.y / cameraRangeY) * bgRangeY;
  }
}
