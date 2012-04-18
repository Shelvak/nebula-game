package tests.utils.classes.tc_objects_containssamedata
{
   public class ObjectProperty
   {
      public function ObjectProperty(id: int, data: Object) {
         this.id = id;
         this.data = data;
      }

      [Required] public var id: int;
      [Required] public var data: Object;
   }
}
