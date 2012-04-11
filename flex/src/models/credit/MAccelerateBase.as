package models.credit
{
   import config.Config;

   import utils.DateUtil;
   import utils.locale.Localizer;
   import utils.StringUtil;

   public class MAccelerateBase
   {
      
      [Bindable]
      public var time: int;
      
      [Bindable]
      public var credits: int;

      public var index: int;
      
      public function MAccelerateBase(_time: String, _credits: int, _index: int)
      {
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