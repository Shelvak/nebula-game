package tests.models.classes
{
   import models.BaseModel;
   
   
   public class ModelNested extends BaseModel
   {
      [Required]
      public var nested:BaseModel;
   }
}