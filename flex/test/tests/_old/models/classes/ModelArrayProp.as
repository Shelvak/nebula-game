package tests._old.models.classes
{
   import models.BaseModel;
   
   public class ModelArrayProp extends BaseModel
   {
      [ArrayElementType("Number")]
      [Required]
      public var numbersInstance:Array = [];
      [ArrayElementType("Number")]
      [Required]
      public var numbersNull:Array = null;
   }
}