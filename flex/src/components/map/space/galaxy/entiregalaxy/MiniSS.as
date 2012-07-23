package components.map.space.galaxy.entiregalaxy
{
import utils.ObjectStringBuilder;


public class MiniSS
   {
      public var type: String;
      public var x: int;
      public var y: int;

      public function MiniSS(coords: Array, type: String) {
         this.x = coords[0];
         this.y = coords[1];
         this.type = type;
      }

      public function toString(): String {
         return new ObjectStringBuilder(this)
            .addProp("type")
            .addProp("x")
            .addProp("y").finish();
      }
   }
}
