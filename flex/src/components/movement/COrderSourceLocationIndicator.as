package components.movement
{
   import spark.components.Group;

   public class COrderSourceLocationIndicator extends Group
   {
      public function COrderSourceLocationIndicator()
      {
         super();
         width = height = 152;
      }
      
      
      override protected function updateDisplayList(uw:Number, uh:Number):void
      {
         super.updateDisplayList(uw, uh);
         graphics.clear();
         graphics.beginFill(0x0000FF, 0.5);
         graphics.drawRect(0, 0, uw, uh);
         graphics.endFill();
      }
   }
}