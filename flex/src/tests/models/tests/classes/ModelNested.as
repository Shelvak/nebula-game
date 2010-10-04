package tests.models.tests.classes
{
   import models.BaseModel;
   
   public class ModelNested extends BaseModel
   {
      [Required]
      public var nested:BaseModel;
   }
}