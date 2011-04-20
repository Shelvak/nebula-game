package tests._old.models.classes
{
   import models.BaseModel;
   
   public class ModelAccessorAndVariable extends BaseModel
   {
      [Required]
      public var variable:int = 0;
      private var _accessor:int = 0;
      [Required]
      public function set accessor(value:int) : void
      {
         _accessor = value;
      }
      public function get accessor() : int
      {
         return _accessor;
      }
   }
}