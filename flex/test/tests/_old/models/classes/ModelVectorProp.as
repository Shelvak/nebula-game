package tests._old.models.classes
{
   import models.BaseModel;
   
   public class ModelVectorProp extends BaseModel
   {
      [Required]
      public var numbersInstance:Vector.<Number> = new Vector.<Number>();
      
      [Required]
      public var numbersNull:Vector.<Number> = null;
   }
}