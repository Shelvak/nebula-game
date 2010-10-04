package components.buildingsidebar
{
   import components.base.BaseSkinnableComponent;
   
   import spark.components.Label;
   
   [SkinState("positive")]
   [SkinState("negative")]

   public class BonusLabel extends BaseSkinnableComponent
   {
      [Bindable]
      public var type: String;
      
      private var _ammount: String;
      
      
      [SkinPart (required="true")]
      public var bonusAmmount: Label;
      
      [SkinPart (required="true")]
      public var bonusType: Label;
      
      [Bindable]
      public function get ammount():String
      {
         return _ammount;
      }
      
      public function set ammount(value: String): void
      {
         _ammount = value;
         invalidateSkinState();
      }
      
      
      override protected function getCurrentSkinState() : String
      {
         if (ammount == null)
            return "positive";
         if (ammount.charAt() == '-')
            return "negative"
         else
            return "positive";
      }
   }
}
