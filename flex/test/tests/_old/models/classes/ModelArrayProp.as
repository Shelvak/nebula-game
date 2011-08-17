package tests._old.models.classes
{
   import models.BaseModel;
   
   public class ModelArrayProp extends BaseModel {
      [Required(elementType="Number")]
      public var numbersInstance:Array = [];
      [Required(elementType="Number")]
      public var numbersNull:Array = null;
   }
}