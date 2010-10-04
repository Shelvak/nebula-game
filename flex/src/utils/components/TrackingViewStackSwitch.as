package utils.components
{
   import utils.datastructures.SimpleStack;
   
   
   /**
    * This type of <code>ViewStackSwitch</code> "remember" previous containers showed and switch back
    * to the last one used.
    * 
    * @see utils.components.ViewStackSwitch
    */
   public class TrackingViewStackSwitch extends ViewStackSwitch
   {
      // Stack for tracking screens
      private var namesStack: SimpleStack = new SimpleStack();
      
      
      /**
       * Clears the list of previously viewed screens and shows the default screen.
       */
      public function resetToDefault() : void
      {
         namesStack.clear();
         currentName = null;
         pushScreen = false;
         showScreen(defaultScreenName);
      }
      
      
      /** 
       * Clears the list of previously viewed screens and leaves currently viewed screen.
       */
      public function resetToCurrent() : void
      {
         namesStack.clear();
      }
      
      
      /**
       * Clears the list of previously viewed screens and shows the screen with a given
       * name.
       * 
       * @param name Name of the screen to show.
       */
      public function resetToScreen(name:String) : void
      {
         namesStack.clear();
         currentName = null;
         pushScreen = false;
         showScreen(name);
      }
      
      
      private var pushScreen:Boolean=true;
      /**
       * Shows previously viewed screen. Has no effect if there are no such screens.
       */
      public function showPrevious() :void
      {
         if (!namesStack.isEmpty)
         {
            pushScreen = false;
            showScreen(namesStack.pop());
         }
         else
         {
            resetToDefault();
         }
      }
      
      
      override public function showScreen(name:String) : void
      {
         if (currentName == name)
            return;
         
         if (currentName != null && pushScreen)
            namesStack.push(currentName);
         
         pushScreen = true;
         
         super.showScreen(name);
      }
      
      
      /**
       * Shows a screen with a given name but does not add current screen
       * to the stack.
       */      
      public function replaceCurrentWith(name:String) : void
      {
         if (currentName == name)
            return;
         
         pushScreen = false;
         showScreen(name);
      }
   }
}