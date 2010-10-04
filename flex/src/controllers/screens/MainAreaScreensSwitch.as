package controllers.screens
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import globalevents.GScreenChangeEvent;
   
   import utils.components.TrackingViewStackSwitch;
   
   
   public class MainAreaScreensSwitch extends TrackingViewStackSwitch
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
         super.showScreen(name);
         changedEvent.dispatch();
      }
   }
}