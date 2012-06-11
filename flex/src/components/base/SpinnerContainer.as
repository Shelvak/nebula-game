package components.base
{
   import components.base.skins.SpinnerContainerSkin;
   
   import controllers.messages.ResponseMessagesTracker;
   
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import mx.controls.ProgressBar;

   import spark.components.Label;

   import spark.components.SkinnableContainer;

   import utils.DateUtil;

   import utils.locale.Localizer;
   import utils.remote.ServerConnector;


   /**
    * While in this state component does not accept user input and spinner
    * is visible and animating.
    */   
   [SkinState ("busy")]
   
   
   /**
    * This is similar to busy. Only difference is that progress bar indicating
    * time left until timeout is shown.
    */ 
   [SkinState ("timeout")]


   /**
    * This is similar to timeout. Only difference is that reestablish button
    * is shown.
    */
   [SkinState ("reestablish")]
   
   
   
   
   /**
    * Skinnable container that has a Spinner component which is shown
    * when the component is marked as busy. Note that although this container
    * defines "disabled" state it never enters it.
    */
   public class SpinnerContainer extends SkinnableContainer
   {
      /**
       * Amount of time in milliseconds when state is changed to timeout. 
       */      
      private static const TIME_UNTIL_TIMEOUT: Number = 3000;
      /**
       * Amount of time in milliseconds until reestablish button is shown.
       */
      private static const TIME_UNTIL_REESTABLISH: Number =
         ServerConnector.CHECK_RESPONSE_TIME + 5000;
      
      
      private var flags: Object = new Object ();
      private var timer: Timer = new Timer (200, 0);
      
      
      private var _timeout: Boolean = false;
      private var _reestablish: Boolean = false;
      /**
       * When this is true, component is in "timeout" state.
       */ 
      private function set timeout (v: Boolean) :void
      {
         _timeout = v;
         flags.timeoutChanged = true;
         
         invalidateProperties ();
         invalidateSkinState ();
      }
      /**
       * When this is true, component is in "reestablish" state.
       */
      private function set reestablish (v: Boolean) :void
      {
         _reestablish = v;
         flags.reestablishChanged = true;

         invalidateProperties ();
         invalidateSkinState ();
      }
      /**
       * @private
       */
      private function get timeout () :Boolean
      {
         return _timeout;
      }
      /**
       * @private
       */
      private function get reestablish () :Boolean
      {
         return _reestablish;
      }
      
      
      private var _busy: Boolean = false;
      /**
       * Indicates if this component is busy (probably waiting for some action
       * is performed by the server or something like that).
       * 
       * @internal When component is busy it should be in busy state as well
       * as should not react to user input.
       * 
       * @default false
       */
      [Bindable]
      public function set busy (v: Boolean) :void
      {
         _busy = v;
         if (!v)
         {
            timeout = false;
            reestablish = false;
         }
         flags.busyChanged = true;
         
         invalidateProperties ();
         invalidateSkinState ();
      }
      /**
       * @private 
       */            
      public function get busy () :Boolean
      {
         return _busy;
      }
      
      
      private var _timeoutEnabled:Boolean = true;
      /**
       * If <code>true</code> progress bar indicating timeout will be shown.
       * 
       * @default true
       */
      public function set timeoutEnabled(v:Boolean) : void
      {
         _timeoutEnabled = v;
         invalidateSkinState();
      }
      /**
       * @private
       */
      public function get timeoutEnabled() : Boolean
      {
         return _timeoutEnabled;
      }
      
      
      /**
       * A spinner that is shown when a component is busy. 
       */      
      [SkinPart (required="true")]
      public var spinner: Spinner = null;
      
      
      /**
       * A progressbar that will be shown after 3 seconds if server does not respond.
       */
      [SkinPart (required="true")]
      public var progress: Label = null;
      
      
      public function SpinnerContainer ()
      {
         super ();
         setStyle ("skinClass", SpinnerContainerSkin);
         timer.addEventListener (TimerEvent.TIMER, timer_eventHandler);
      }
      
      
      override protected function commitProperties () :void
      {
         super.commitProperties ();
         
         if (spinner && flags.busyChanged)
         {
            contentGroup.enabled = !busy;
            
            if (busy)
            {
               spinner.play ();
               timer.start ();
            }
            else
            {
               spinner.stop ();
               timer.reset ();
            }
         }
         
         flags = new Object ();
      }
      
      
      override protected function getCurrentSkinState () :String
      {
         if (busy && timeout && timeoutEnabled)
         {
            if (reestablish)
            {
               return "reestablish";
            }
            else
            {
               return "timeout";
            }
         }
         else if (busy)
         {
            return "busy";
         }
         else
         {
            return super.getCurrentSkinState ();
         }
      }
      
      private function timer_eventHandler (event: TimerEvent) :void
      {
         if (progress)
         {
            progress.text = Localizer.bundlesSet
               ? DateUtil.secondsToHumanString(
                  timer.currentCount * timer.delay / 1000)
               : '';
         }
         if (timer.currentCount * timer.delay == TIME_UNTIL_TIMEOUT)
         {
            timeout = true;
         }
         if (timer.currentCount * timer.delay == TIME_UNTIL_REESTABLISH)
         {
            reestablish = true;
         }
      }
   }
}