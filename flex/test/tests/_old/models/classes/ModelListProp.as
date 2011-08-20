package tests._old.models.classes
{
   import models.BaseModel;
   
   import mx.collections.ArrayCollection;
   
   
   public class ModelListProp extends BaseModel
   {
      [Required(elementType="Number")]
      public var numbersInstance:ArrayCollection = new ArrayCollection();
      [Required(elementType="Number")]
      public var numbersNull:ArrayCollection = null;
   }
}