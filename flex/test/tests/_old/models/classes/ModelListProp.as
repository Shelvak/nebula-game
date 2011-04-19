package tests._old.models.classes
{
   import models.BaseModel;
   
   import mx.collections.ArrayCollection;
   
   
   public class ModelListProp extends BaseModel
   {
      [ArrayElementType("Number")]
      [Required]
      public var numbersInstance:ArrayCollection = new ArrayCollection();
      [ArrayElementType("Number")]
      [Required]
      public var numbersNull:ArrayCollection = null;
   }
}