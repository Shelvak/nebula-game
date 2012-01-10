package styles
{
   public class LinkState
   {
      public function LinkState(color:uint,
                                textDecoration:String,
                                fontWeight:String) {
         this.color = color;
         this.textDecoration = textDecoration;
         this.fontWeight = fontWeight;
      }

      public var color:uint;
      public var textDecoration:String;
      public var fontWeight:String;
   }
}
