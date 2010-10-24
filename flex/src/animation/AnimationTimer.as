package animation
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;

   
   /**
    * Dispatched whenever an <code>AnimationTimer</code> object reaches an interval specified
    * according to the <code>AnimationTimer.delay</code> property.
    * 
    * @eventType flash.events.TimerEvent.TIMER
    */
   [Event(name="timer", type="flash.events.TimerEvent")]
   
   
   /**
    * Used by <code>SequencePlayer</code> for animation sequence automatic playback.
    */
   public class AnimationTimer implements IEventDispatcher
   {
      /**
       * Default delay (in milliseconds) between frames in battle animation is <strong>100</strong> 
       */
      public static const DEFAULT_BATTLE_ANIM_DELAY:int = 50;
      
      
      /**
       * Default delay (in milliseconds) between frames in planet animation is <strong>100</strong> 
       */
      public static const DEFAULT_PLANET_ANIM_DELAY:int = 100;
      
      
      /**
       * Default delay (in milliseconds) between frames in ui animation is <strong>100</strong> 
       */
      public static const DEFAULT_UI_ANIM_DELAY:int = 15;
      
      
      private static var _battleInstance:AnimationTimer = null;
      /**
       * @return instace for use in battle animation
       */
      public static function get forBattle() : AnimationTimer
      {
         if (!_battleInstance)
         {
            _battleInstance = new AnimationTimer(DEFAULT_BATTLE_ANIM_DELAY);
         }
         return _battleInstance;
      }
      
      
      private static var _planetMapInstance:AnimationTimer = null;
      /**
       * @return instance for use in planet map animation
       */
      public static function get forPlanet() : AnimationTimer
      {
         if (!_planetMapInstance)
         {
            _planetMapInstance = new AnimationTimer(DEFAULT_PLANET_ANIM_DELAY);
         }
         return _planetMapInstance;
      }
      
      
      private static var _uiInstance:AnimationTimer = null;
      /**
       * @return instance for use in ui animation
       */
      public static function get forUi() : AnimationTimer
      {
         if (!_uiInstance)
         {
            _uiInstance = new AnimationTimer(DEFAULT_UI_ANIM_DELAY);
         }
         return _uiInstance;
      }
      
      
      private var _defaultDelay:Number;
      private var _timer:Timer;
      /**
       * Constructor. The timer is not started automaticly: you must start it manually with
       * <code>start()</code> method.
       *  
       * @param defaultDelay default and stating delay value for the timer in milliseconds
       */
      public function AnimationTimer(defaultDelay:Number)
      {
         _defaultDelay = defaultDelay;
         _timer = new Timer(defaultDelay);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      /**
       * Indicates if the timer is running.
       */
      public function get isRunning() : Boolean
      {
         return _timer.running;
      }
      
      
      /**
       * Delay between <code>TimerEvent.TIMER</code> events.
       * 
       * @see Timer#delay
       */
      public function set delay(value:Number) : void
      {
         _timer.delay = value;
      }
      /**
       * @private
       */
      public function get delay() : Number
      {
         return _timer.delay;
      }
      
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Short variant of <code>addEventListener(TimerEvent.TIMER, listener, false,
       * priority, useWeakReference)</code>.
       * 
       * @see #addEventListener()
       */
      public function addListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         addEventListener(TimerEvent.TIMER, listener, false, priority, useWeakReference);
      }
      
      
      /**
       * Short variant of <code>removeEventListener(TimerEvent.TIMER, listener)</code>.
       * 
       * @see #removeEventListener()
       */
      public function removeListener(listener:Function) : void
      {
         removeEventListener(TimerEvent.TIMER, listener);
      }
      
      
      /**
       * Stops the timer if it is running.
       * 
       * @see #isRunning
       * @see #start()
       */
      public function stop() : void
      {
         if (_timer.running)
         {
            _timer.stop();
         }
      }
      
      
      /**
       * Starts the timer if it is not running.
       * 
       * @see #isRunning
       * @see #stop()
       */
      public function start() : void
      {
         if (!_timer.running)
         {
            _timer.start();
         }
      }
      
      
      /**
       * Sets <code>delay</code> to default value.
       * 
       * @see #delay
       */
      public function setDelayToDefault() : void
      {
         delay = _defaultDelay;
      }
      
      
      /* ################################ */
      /* ### IEVENTDISPATCHER METHODS ### */
      /* ################################ */
      
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false,
                                       priority:int = 0, useWeakReference:Boolean = false) : void
      {
         _timer.addEventListener(type, listener, useCapture, priority, useWeakReference);
      }
      
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         _timer.removeEventListener(type, listener, useCapture);
      }
      
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return _timer.dispatchEvent(event);
      }
      
      
      public function hasEventListener(type:String) : Boolean
      {
         return _timer.hasEventListener(type);
      }
      
      
      public function willTrigger(type:String) : Boolean
      {
         return _timer.willTrigger(type);
      }
   }
}