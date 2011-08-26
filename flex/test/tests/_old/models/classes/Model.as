package tests._old.models.classes
{
   import models.BaseModel;

   public class Model extends BaseModel
   {
      public var name:String = "";
      public var surname:String = "";      
      
      private var _age:int = 0;
      public function get age() : int {
         return _age;
      }
      public function set age(v:int) : void {
         _age = v;
      }
   }
}