package controllers.screens
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.GlobalFlags;
   
   import globalevents.GScreenChangeEvent;
   
   import models.events.ScreensSwitchEvent;
   
   import utils.components.TrackingViewStackSwitch;
   
   
   public final class MainAreaScreensSwitch extends TrackingViewStackSwitch
   {
      public static function getInstance() : MainAreaScreensSwitch
      {
         return SingletonFactory.getSingletonInstance(MainAreaScreensSwitch);
      }
      
      override public function showScreen(name:String) : void
      {
         if (name == currentName)
            return;
         
         var changedEvent:GScreenChangeEvent = new GScreenChangeEvent(
            GScreenChangeEvent.MAIN_AREA_CHANGED,
            currentName, name, viewStack, false);
         var changingEvent:GScreenChangeEvent = new GScreenChangeEvent(
            GScreenChangeEvent.MAIN_AREA_CHANGING,
            currentName, name, viewStack, false
         );
         
         changingEvent.dispatch();
         function dispatchChangedEvent(e: ScreensSwitchEvent): void
         {
            removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, dispatchChangedEvent);
            changedEvent.dispatch();
         }
         GlobalFlags.getInstance().lockApplication = false;
         addEventListener(ScreensSwitchEvent.SCREEN_CREATED, dispatchChangedEvent);
         super.showScreen(name);
      }
   }
}