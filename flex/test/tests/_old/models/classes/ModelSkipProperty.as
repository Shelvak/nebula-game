package tests._old.models.classes
{
   import models.BaseModel;

   public class ModelSkipProperty extends BaseModel
   {
      [SkipProperty]
      public var skipVariable:int = 0;
      private var _skipAccessor:int = 0;
      [SkipProperty]
      public function set skipAccessor(value:int) : void {
         _skipAccessor = value;
      }
      public function get skipAccessor() : int {
         return _skipAccessor;
      }
      
      public var notSkipVariable:Number = 0;
      private var _notSkipAccessor:Number = 0;
      public function set notSkipAccessor(value:Number) : void {
         _notSkipAccessor = value;
      }
      public function get notSkipAccessor() : Number {
         return _notSkipAccessor;
      }
   }
}