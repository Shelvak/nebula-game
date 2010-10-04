package components.base
{
   import components.markers.ISystemCursorUser;
   
   import flash.events.FocusEvent;
   
   import spark.components.TextInput;
   
   
   /**
    * Component enters this state when it gains focus. 
    */   
   [SkinState("focused")]
   
   public class BaseTextInput extends TextInput implements ISystemCursorUser
   {
      public function BaseTextInput ()
      {
         super ();
         addEventListener(FocusEvent.FOCUS_IN, this_focusInHandler);
         addEventListener(FocusEvent.FOCUS_OUT, this_focusOutHandler);
      }
      
      
      private var fFocused: Boolean = false;
      private function this_focusInHandler (event: FocusEvent) :void
      {
         fFocused = true;
         invalidateSkinState();
      }
      private function this_focusOutHandler (event: FocusEvent) :void
      {
         fFocused = false;
         invalidateSkinState();
      }
      
      
      override protected function getCurrentSkinState () :String
      {
         if (fFocused)
         {
            return "focused";
         }
         else
         {
            return super.getCurrentSkinState();
         }
      }
   }
}