class Level {
  public var world : World;
  public var time : Float;
  public var isActive : Bool;

  public function new(worldPath : String, ?tileSize = 32) {
    time = 0.0;
    world = new World(worldPath, tileSize);
    world.draw();
    isActive = true;
  }
}
