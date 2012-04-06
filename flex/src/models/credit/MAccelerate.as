package models.credit
{
   import spark.components.RadioButtonGroup;

   public class MAccelerate extends MAccelerateBase
   {
      [Bindable]
      public var group: RadioButtonGroup;

      public var index: int;
      
      public function MAccelerate(_time: String, _credits: int, rGroup: RadioButtonGroup, _index: int)
      {
         super(_time, _credits);
         group = rGroup;
         index = _index;
      }
   }
}