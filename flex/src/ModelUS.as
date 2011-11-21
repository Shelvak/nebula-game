package
{
   import models.BaseModel;
   
   public class ModelUS extends BaseModel
   {
      public function ModelUS()
      {
         super();
      }
      
      [Required] public var prop_one:String = "";
      [Required] public var prop_two:String = "";
      [Required] public var prop_three:String = "";
   }
}