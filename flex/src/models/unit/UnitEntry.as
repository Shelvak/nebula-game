package models.unit
{
   import flash.display.BitmapData;
   
   import models.BaseModel;
   
   import utils.StringUtil;
   import utils.assets.AssetNames;
   
   public class UnitEntry extends BaseModel
   {
      /**
       * Constructor.
       * 
       * @param type type of a building or unit
       * @param count count of constructables deacticvated or cancelled
       */
      public function UnitEntry(type:String = "", count:int = 0)
      {
         super();
         _type = StringUtil.firstToUpperCase(type);
         _count = count;
      }
      
      
      private var _type:String = null;
      [Required]
      [Bindable(event="willNotChange")]
      /**
       * Type of units that are part of a squadron.
       */
      public function set type(value:String) : void
      {
         _type = StringUtil.firstToUpperCase(value);
      }
      /**
       * @private
       */
      public function get type() : String
      {
         return _type;
      }
      
      
      private var _count:uint = 0;
      [Required]
      [Bindable]
      /**
       * How many units of this <code>type</code> are in a squadron.
       */
      public function set count(value:uint) : void
      {
         _count = value;
      }
      /**
       * @private
       */
      public function get count() : uint
      {
         return _count;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Image of this unit type.
       */
      public function get imageData() : BitmapData
      {
         return IMG.getImage(AssetNames.getUnitImageName(type));
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className + ", type: " + type + ", count: " + count + "]";
      }
   }
}