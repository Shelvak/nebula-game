package models.credit
{
   import config.Config;
   
   import spark.components.RadioButtonGroup;
   
   import utils.DateUtil;
   import utils.Localizer;
   import utils.StringUtil;

   public class MAccelerate
   {
      [Bindable]
      public var group: RadioButtonGroup;
      
      [Bindable]
      public var time: int;
      
      [Bindable]
      public var credits: int;
      
      public var index: int;
      
      public function MAccelerate(_time: String, _credits: int, rGroup: RadioButtonGroup, _index: int)
      {
         group = rGroup;
         time = Math.ceil(StringUtil.evalFormula(_time, {'speed': Config.getSpeed()}));
         credits = _credits;
         index = _index;
      }
      
      public function getAccelerateTimeString(): String
      {
         if (time > 0)
         {
         return DateUtil.secondsToHumanString(time);
         }
         else
         {
            return Localizer.string('Credits', 'label.instant');
         }
      }
   }
}