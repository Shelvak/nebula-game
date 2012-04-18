package tests.utils.classes.tc_objects_containssamedata
{
   import flash.geom.Point;


   public class TypeProcessorProperty
   {
      public function TypeProcessorProperty(id: int, point: Point) {
         this.id = id;
         this.point = point;
      }

      [Required] public var id: int;
      [Required] public var point: Point;
   }
}
