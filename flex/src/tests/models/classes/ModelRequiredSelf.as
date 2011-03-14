package tests.models.classes
{
   import models.BaseModel;
   
   
   public class ModelRequiredSelf extends BaseModel
   {
      [Required]
      public var self:ModelRequiredSelf;
   }
}