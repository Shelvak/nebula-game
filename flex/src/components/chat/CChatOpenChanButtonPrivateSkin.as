package components.chat
{
   public class CChatOpenChanButtonPrivateSkin extends CChatOpenChanButtonSkin
   {
      public function CChatOpenChanButtonPrivateSkin()
      {
         super();
      }
      
      
      protected override function get specificKeyPart() : String
      {
         return "private";
      }
   }
}