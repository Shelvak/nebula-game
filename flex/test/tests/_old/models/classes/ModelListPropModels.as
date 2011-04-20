package tests._old.models.classes
{
   import models.BaseModel;
   
   
   public class ModelListPropModels extends BaseModel
   {
      [ArrayElementType("models.BaseModel")]
      [Required]
      public var models:Array = null;
   }
}