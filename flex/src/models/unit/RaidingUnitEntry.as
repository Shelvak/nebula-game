package models.unit
{
   import flash.display.BitmapData;
   
   import models.BaseModel;
   import utils.StringUtil;
   import utils.assets.AssetNames;
   
   
   public class RaidingUnitEntry extends BaseModel
   {
      public function RaidingUnitEntry(_type:String, _countFrom:int,
              _countTo: int, _prob: Number)
      {
         super();
         type = StringUtil.underscoreToCamelCase(_type);
         countFrom = _countFrom;
         countTo = _countTo;
         prob = _prob;
      };
      
      [Bindable]
      public var type:String = null;
      [Bindable]
      public var countFrom:int;
      [Bindable]
      public var countTo:int;
      [Bindable]
      public var prob:Number = 0;
      
      [Bindable(event="willNotChange")]
      /**
       * Image of this unit.
       */
      public function get imageData() : BitmapData
      {
         return IMG.getImage(AssetNames.getUnitImageName(type));
      }
      
      public override function toString() : String
      {
         return "[class: " + className + ", type: " + type + ", countFrom: "
                 + countFrom + ", countTo: " + countTo + ", prob: " + prob + "]";
      }
   }
}