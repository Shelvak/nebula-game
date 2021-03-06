package globalevents
{
   import com.developmentarc.core.actions.commands.AbstractCommand;
   import com.developmentarc.core.utils.EventBroker;
   
   
   /**
    * Base class for events dispatched through <code>EventBroker</code>. 
    */   
   public class GlobalEvent extends AbstractCommand
   {
      /**
       * Dispatched when player has logged out or has been disconnected from the server fore some
       * reason. Every heavyweight component - a component that is used during whole
       * application lifecycle - should listent for this event and once it receives it the component
       * (or any other heavyweight object for that matter) should do a total cleanup of it's
       * resources, event listeners, destroy children and cleanup them. By "total cleanup" I do not
       * mean it should destroy everything: you should consider what must be destroyed and which
       * listeners should be unregistered and what can be left intact. In most cases those
       * heavyweight objects will have to destroy their children, unregister any event listeners
       * with all objects except for <code>EventBroker</code>. 
       */
      public static const APP_RESET:String = "applicationReset";
      
      /**
       * Dispatched when player has loggen in and all initial models and lists of models have been created.
       * This method is dispatched after <code>galaxies|show</code> has been processed. 
       */ 
      public static const APP_READY:String = "applicationReady";
      
      
      /**
       * Dispatched each time FP starts a new frame. All models, controllers, components or other objects
       * should listen for this event and update themselves (or objects they are managing) each time the
       * event is dispatched taking into account current time which <b>must</b> be retrieved via
       * <code>DateUtil.nowDate</code> or <code>DateUtil.nowTime</code>
       */
      public static const TIMED_UPDATE:String = "timedUpdate";

      public static const INITIALIZE_MAP_EDITOR:String = "initializeMapEditor";
      
      
      /**
       * Convenience function for subscribing for <code>TIMED_UPDATE</code> global event.
       * 
       * @see #unsubscribe_TIMED_UPDATE()
       */
      public static function subscribe_TIMED_UPDATE(handler:Function) : void
      {
         EventBroker.subscribe(TIMED_UPDATE, handler);
      }
      
      
      /**
       * Convenience function for unsubscribing for <code>TIMED_UPDATE</code> global event.
       * 
       * @see #subscribe_TIMED_UPDATE()
       */
      public static function unsubscribe_TIMED_UPDATE(handler:Function) : void
      {
         EventBroker.unsubscribe(TIMED_UPDATE, handler);
      }
      
      
      /**
       * Indicates if this event has been dispatched already.
       * The same event object can be dispached only once. 
       */      
      private var dispatched:Boolean = false;
      
      
      /**
       * Constructor. Note that in order eager dispatch feature to work properly in any derived
       * class <code>super(type,eagerDispatch)</code> should be <strong>the last
       * statement in the constructor</strong>. Otherwise one could end up with lots of
       * exceptions.
       * 
       * @param type Type of the event.
       * @param eagerDispatch If <code>true</code>, the event will be dispached once it
       * has been created. If <code>false</code>, you will have to call <code>dispatch()</code>
       * yourself or use <code>EventBroker</code> for this purpose.
       */
      public function GlobalEvent(type:String, eagerDispatch:Boolean = true)
      {
         super(type);
         if (eagerDispatch)
         {
            dispatch();
         }
      }
      
      
      /**
       * Dispatches this event: broadcasts it by means of <code>EventBroker</code>.
       * 
       * @throws Error if this event object has already been dispatched. 
       */
      override public function dispatch() : void
      {
         if (dispatched)
         {
            throw new Error("The same GlobalEvent object can be dispatched only once. If you need " +
                            "a workaround, use EventBroker directly.");
         }
         else
         {
            dispatched = true;
            super.dispatch();
         }
      }
   }
}