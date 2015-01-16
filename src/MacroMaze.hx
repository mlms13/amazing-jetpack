using StringTools;
import haxe.macro.Context;

class MacroMaze {
  macro public static function load(filename : String) {
    var content = sys.io.File.getContent(filename);
    // parse file contents to Array<Array<String>>
    var chars = tokenize(content);
    var code = mapToEnumCode(chars);

    return Context.parse(code, Context.currentPos());
  }

  #if macro
    static function tokenize(content : String) : Array<Array<String>> {
      return content.split("\n").map(function (line) {
        return line.trim().split(" ");
      });
    }

    static function mapToEnumCode(chars : Array<Array<String>>) {
      return "[" + chars.map(function(line) {
        return "[" + line.map(function(char) return switch char {
          case ".": "MazeCell.open";
          case "x": "MazeCell.wall";
          case "1","2","3","4","5","6": 'MazeCell.powerUp($char)';
          case c: throw 'damnit I knew you would use the invalid char "$c"';
        }).join(", ") + "]";
      }).join(", ") + "]";
    }
  #end
}
