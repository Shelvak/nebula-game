package
{
   import models.BaseModel;

   public class ModelCC extends BaseModel
   {
      public function ModelCC()
      {
         super();
      }
      
      [Required] public var propOne:String = "";
      [Required] public var propTwo:String = "";
      [Required] public var propThree:String = "";
   }
}