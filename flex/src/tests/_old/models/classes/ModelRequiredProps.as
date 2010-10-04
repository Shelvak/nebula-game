package tests._old.models.classes
{
   import models.BaseModel;
   
   public class ModelRequiredProps extends BaseModel
   {
      [Required]
      public var name:String = "";
      [Required]
      public var age:int = 0;
   }
}