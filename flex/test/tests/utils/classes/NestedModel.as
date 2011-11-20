package tests.utils.classes
{
   import models.BaseModel;
   
   public class NestedModel extends BaseModel
   {
      [Required] public var nested:BaseModel;
   }
}