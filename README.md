# Amazing Jetpack!

This is my January entry for the [Serious Biz](https://github.com/seriousbiz) game-a-month challenge. It isn't a particularly fun game, but that could possibly change with a little work.

### Build it yourself

The game is written in Haxe and it depends on the dev version of [Luxe](http://luxeengine.com/docs/setup.html). Once you have that working, you should be able to `cd` into the amazing-jetpack directory and `flow run` to see all of the beauty.

If you feel like modifying any of the sprites or tiles, you can find them in `_materials`. To generate the spritesheet for the animated penguin, I use the follwing [Fish](http://fishshell.com/) script on Ubuntu. Prefer bash instead? You're smart. You'll figure it out.

```sh
cd _materials

for i in *.svg
  inkscape -f $i -e $i.png
end

convert penguin*.svg.png +append ../assets/penguin_animation.png
```
