package tests._old.models.classes
{
   import models.BaseModel;
   
   
   public class ModelListPropModels extends BaseModel
   {
      [Required(elementType="models.BaseModel")]
      public var models:Array = null;
   }
}