package models.credit
{
   import config.Config;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.RadioButtonGroup;
   
   import utils.DateUtil;
   
   public class VipLevelsData
   {
      private static const COST: int = 0;
      private static const DAILY: int = 1;
      private static const DURATION: int = 2;
      
      [Bindable]
      public static var vipSelection: RadioButtonGroup = new RadioButtonGroup();
      
      public static function getSelectedLevel(): int
      {
         if (vipSelection.selection)
         {
            return int(vipSelection.selectedValue);
         }
         else
         {
            return 0;
         }
      }
      
      public static function getVipConvertedCreds(level: int, from: int): int
      {
         return Math.floor(from/getVipConvertRate(level));
      }
      
      public static function getVipConvertRate(level: int): Number
      {
         return Math.floor(getVipDailyBonus(level) * Config.getVipBonus(level)[DURATION] / 
            (3600 * 24) / getVipCost(level)) + 0.5;
      }
      
      public static function getVipCost(level: int): int
      {
         return Config.getVipBonus(level)[COST];
      }
      public static function getVipDailyBonus(level: int): int
      {
         return Config.getVipBonus(level)[DAILY];
      }
      public static function getVipDuration(level: int): String
      {
         return DateUtil.secondsToHumanString(Config.getVipBonus(level)[DURATION]);
      }
      public static function getVipTotalCreds(level: int): int
      {
         return getVipDailyBonus(level) *
            Math.floor(Config.getVipBonus(level)[DURATION]/3600/24);
      }
      public static function getVipBonusRate(level: int): int
      {
         return Math.round(getVipTotalCreds(level)/getVipCost(level));
      }
      public static function getDataProvider(): ArrayCollection
      {
         var dProvider: ArrayCollection = new ArrayCollection();
         for (var i: int = 1; i <= Config.getVipMaxLevel(); i++)
         {
            dProvider.addItem({'group': vipSelection, 'level': i});
         }
         return dProvider;
      }
   }
}