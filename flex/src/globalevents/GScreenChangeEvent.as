package globalevents
{
   import mx.containers.ViewStack;
   
   
   public class GScreenChangeEvent extends GlobalEvent
   {
      /**
       * Dispatched when a view stack is switched to a new screen.
       * 
       * @eventType screenChange
       */
      public static const SCREEN_CHANGE:String = "screenChange";
      
      public static const SIDEBAR_CHANGE:String = "sidebarChange";
      
      
      private var _newScreenName:String;
      /**
       * Name of the screen that the view stack has been switched <strong>to</strong>.
       */
      public function get newScreenName() : String
      {
         return _newScreenName;
      }
      
      private var _oldScreenName:String;
      /**
       * Name of the screen that the view stack has been switched <strong>from</strong>. 
       */      
      public function get oldScreenName() : String
      {
         return _oldScreenName;
      }
      
      private var _viewStack:ViewStack;
      /**
       * A view stack that was switch to the new screen. 
       */
      public function get viewStack() : ViewStack
      {
         return _viewStack;
      }
      
      
      /**
       * Constructor. 
       */
      public function GScreenChangeEvent
         (type:String,
          oldScreenName:String,
          newScreenName:String,
          viewStack:ViewStack,
          eagerDispatch:Boolean=true)
      {
         _oldScreenName = oldScreenName;
         _newScreenName = newScreenName;
         _viewStack = viewStack;
         super(type, eagerDispatch);
      }
   }
}