package controllers.navigation
{
   import controllers.GlobalFlags;
   
   import flash.events.EventDispatcher;
   
   import models.events.ScreensSwitchEvent;
   
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   
   import utils.datastructures.SimpleStack;

   public class Navigation extends EventDispatcher
   {
      
      // Stack for tracking screens
      private var namesStack: SimpleStack = new SimpleStack();
      
      protected function get defaultScreen(): String
      {
         throw new Error('You must override this method');
         return null; //unreachable
      }
      
      public var currentName: String;
      
      /**
       * 
       * @param name - new screen name
       * @param unlockAfter - should we remove pending flag after screen show
       * 
       */      
      public function showScreen(name:String, unlockAfter: Boolean = true,
         pushToStack: Boolean = true) : void
      {
         if (name == currentName)
            return;
         if (pushToStack)
         {
            namesStack.push(currentName);
         }
         dispatchScreenChangingEvent();
         currentName = name;
         if (unlockAfter)
         {
            GlobalFlags.getInstance().lockApplication = false;
         }
         dispatchScreenChangedEvent()
      }    
      
      /**
      * Clears the list of previously viewed screens and shows the default screen.
      */
      public function resetToDefault() : void
      {
         showScreen(defaultScreen);
         resetStack();
      }
      
      private function resetStack(): void
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
         showScreen(name);
         resetStack()
      }
      
      /**
       * Shows previously viewed screen. Has no effect if there are no such screens.
       */
      public function showPrevious() :void
      {
         if (!namesStack.isEmpty)
         {
            showScreen(namesStack.pop(), true, false);
         }
         else
         {
            resetToDefault();
         }
      }
      
      public function addMapElements(screen:String,
                                     viewport: IVisualElement, 
                                     controller: IVisualElement): void {
         dispatchMapElementsAddedEvent(screen, viewport, controller);
      }
      
      /**
       * Shows a screen with a given name but does not add current screen
       * to the stack.
       */      
      public function replaceCurrentWith(name:String) : void
      {
         if (currentName == name)
            return;
         
         showScreen(name, true, false);
      }
      
      public function destroyScreenMap(screenName: String): void
      {
         if (hasEventListener(ScreensSwitchEvent.DESTROY_MAP_ELEMENTS))
         {
            dispatchEvent(new ScreensSwitchEvent(
               ScreensSwitchEvent.DESTROY_MAP_ELEMENTS, screenName)); 
         }
      }
      
      public var containerLoaded: Boolean = false;
      
      public function mainContainerCreationHandler(e: FlexEvent): void
      {
         containerLoaded = true;
         dispatchContainerLoadedEvent();
      }
      
      private function dispatchScreenChangingEvent(): void
      {
         if (hasEventListener(ScreensSwitchEvent.SCREEN_CHANGING))
         {
            dispatchEvent(new ScreensSwitchEvent(ScreensSwitchEvent.SCREEN_CHANGING));
         }
      } 
      
      private function dispatchScreenChangedEvent(): void
      {
         if (hasEventListener(ScreensSwitchEvent.SCREEN_CHANGED))
         {
            dispatchEvent(new ScreensSwitchEvent(ScreensSwitchEvent.SCREEN_CHANGED));
         }
      }  
      
      private function dispatchMapElementsAddedEvent(screen:String,
                                                     viewport:IVisualElement,
                                                     controller:IVisualElement) : void
      {
         if (hasEventListener(ScreensSwitchEvent.MAP_ELEMENTS_ADDED))
         {
            dispatchEvent(new ScreensSwitchEvent(
               ScreensSwitchEvent.MAP_ELEMENTS_ADDED,
               screen, viewport, controller
            ));
         }
      } 
      
      private function dispatchContainerLoadedEvent(): void
      {
         if (hasEventListener(ScreensSwitchEvent.CONTAINER_LOADED))
         {
            dispatchEvent(new ScreensSwitchEvent(ScreensSwitchEvent.CONTAINER_LOADED));
         }
      } 
   }
}