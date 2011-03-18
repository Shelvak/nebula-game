package controllers.screens
{
   import utils.SingletonFactory;
   
   import globalevents.GScreenChangeEvent;
   
   import utils.components.ViewStackSwitch;
   
   
   /**
    * Dispatched through <code>EventBroker</code> when a view stack is switched
    * to a new screen.
    * 
    * @eventType globalevents.GScreenChangeEvent.CHANGE
    */
   [Event (name="screenChange",
           type="globalevents.GScreenChangeEvent")]
   
   
   /**
    * Manages top level screens.
    * 
    * <p>This class should be treated as a singleton and instance of it should
    * be retrieved either using static method <code>getInstance()</code> or
    * using <code>utils.SingletonFactory</code>.</p>
    */
   public class ScreensSwitch extends ViewStackSwitch
   {
      /**
       * @return instance of <code>ScreensSwitch</code> for application wide use.
       */
      public static function getInstance() : ScreensSwitch
      {
         return SingletonFactory.getSingletonInstance(ScreensSwitch);
      }
      
      override public function showScreen(name:String) : void
      {
         if (name == currentName)
            return;
         
         var e:GScreenChangeEvent = new GScreenChangeEvent
            (GScreenChangeEvent.SCREEN_CHANGE, currentName,name,viewStack,false);
         super.showScreen(name);
         e.dispatch();
      }
   }
}