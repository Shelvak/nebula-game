package controllers.screens
{
   import utils.SingletonFactory;
   
   import globalevents.GScreenChangeEvent;
   
   import utils.components.TrackingViewStackSwitch;
   
   public final class SidebarScreensSwitch extends TrackingViewStackSwitch
   {
      public static function getInstance() : SidebarScreensSwitch
      {
         return SingletonFactory.getSingletonInstance(SidebarScreensSwitch);
      }
      
      override public function showScreen(name:String) : void
      {
         if (name == currentName)
            return;
         
         var e:GScreenChangeEvent = new GScreenChangeEvent
            (GScreenChangeEvent.SIDEBAR_CHANGE, currentName, name, viewStack, false);
         super.showScreen(name);
         e.dispatch();
      }
   }
}