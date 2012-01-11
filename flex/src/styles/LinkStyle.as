package styles
{
   import flash.text.engine.FontWeight;

   import flashx.textLayout.formats.TextDecoration;


   public final class LinkStyle
   {
      public static const APP_URL:LinkStyle = new LinkStyle(
         new LinkState(0xFFC000, TextDecoration.NONE, FontWeight.BOLD),
         new LinkState(0x00D8E3, TextDecoration.NONE, FontWeight.BOLD),
         new LinkState(0x00D8E3, TextDecoration.NONE, FontWeight.BOLD)
      );
      public static const CHAT_URL:LinkStyle = new LinkStyle(
         new LinkState(0x00D8E3, TextDecoration.NONE, FontWeight.NORMAL),
         new LinkState(0x00D8E3, TextDecoration.NONE, FontWeight.NORMAL),
         new LinkState(0x00D8E3, TextDecoration.NONE, FontWeight.NORMAL)
      );
      public static const EXTERNAL_URL:LinkStyle = CHAT_URL;

      public var normalState: LinkState;
      public var activeState: LinkState;
      public var hoverState: LinkState;

      public function LinkStyle(normalState: LinkState,
                                activeState: LinkState,
                                hoverState: LinkState) {
         this.normalState = normalState;
         this.activeState = activeState;
         this.hoverState = hoverState;
      }
   }
}
