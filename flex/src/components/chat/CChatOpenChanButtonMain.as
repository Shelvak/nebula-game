package components.chat
{
   import flash.events.MouseEvent;
   
   
   public class CChatOpenChanButtonMain extends CChatOpenChanButton
   {
      public function CChatOpenChanButtonMain()
      {
         super();
//         toolTip = getString("tooltip.mainChannel");
      }
      
      
      public override function get imageKeySpecificPart() : String
      {
         return "main";
      }
      
      
      protected override function this_clickHandler(event:MouseEvent) : void
      {
         super.this_clickHandler(event);
         MCHAT.selectMainChannel();
      }
   }
}