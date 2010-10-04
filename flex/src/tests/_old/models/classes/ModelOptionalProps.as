package tests._old.models.classes
{
   import models.BaseModel;
   
   public class ModelOptionalProps extends BaseModel
   {
      [Optional]
      public var name:String = "";
      [Optional]
      public var age:int = 0;
   }
}