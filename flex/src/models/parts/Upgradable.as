package models.parts
{
   import config.Config;
   
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import models.parts.events.UpgradeEvent;
   import models.resource.ResourceType;
   import models.resource.ResourcesAmount;
   import models.solarsystem.MSSObject;
   
   import utils.DateUtil;
   import utils.StringUtil;

   
   /**
    * Dispatched when any upgradable property - and as a result
    * <code>upgradeCompleted</code> - has changed.
    * 
    * @eventType models.parts.events.UpgradeEvent.UPGRADE_PROP_CHANGE
    */
   [Event(name="upgradePropChange", type="models.parts.events.UpgradeEvent")]
   
   
   /**
    * Dispatched when <code>level</code> property has changed.
    * 
    * @eventType models.parts.events.UpgradeEvent.LVL_CHANGE
    */
   [Event(name="lvlChange", type="models.parts.events.UpgradeEvent")]
   
   /**
    * Dispatched when <code>upgradeProgress</code> property changes.
    * 
    * @eventType models.parts.events.UpgradeEvent.UPGRADE_PROGRESS
    */
   [Event(name="upgradeProgress", type="models.parts.events.UpgradeEvent")]
   
   
   
   /**
    * All static <code>calculate...()</code> methods return rounded values (if needed) and should not be modified
    * further. 
    */
   public class Upgradable extends EventDispatcher
   {
      /**
       * Retrieves formula for some upgradable property calculation from config, evaluates in and
       * returns the result.
       * 
       * @param upgradableType one of upgradable types in <code>UpgradableType</code>
       * @param upgradableSubtype subtype (type of unit, technology or building in most cases) of the upgradable
       * @param property the rest of the property to be evaluated
       * @param params parameters specific to the given upgradable type and property to be calculated
       * 
       * @return result of formula evaluation
       * 
       * @throws ArgumentError if formula could not be found
       */
      public static function evalUpgradableFormula(upgradableType:String,
                                                   upgradableSubtype:String,
                                                   property:String,
                                                   params:Object) : Number
      {
         var key:String = upgradableType + "." +
                          StringUtil.firstToLowerCase(upgradableSubtype) + "." +
                          property;
         var formula:String = Config.getValue(key);
         if (!formula)
         {
            throw new ArgumentError("Property of an upgradable not found: " + key);
         }
         return StringUtil.evalFormula(formula, params);
      }
      
      
      /**
       * Calculates and returns cost of the given upgradable.
       * 
       * @param upgradableType one of upgradable types in <code>UpgradableType</code>
       * @param upgradableSubtype subtype (type of unit, technology or building in most cases) of the upgradable
       * @param resourceType type of the resource to calculate (one of constants in
       * <code>ResourceTypeClass</code>).<br/>
       * <code>ResourceTypeClass.TIME</code> is not supported by this method.
       * Use <code>calculateUpgradeTime()</code> method instead.<br/>
       * <code>ResourceTypeClass.SCIENTISTS</code> is not supported by this method.
       * Use <code>Config.getTechnologyMinScientists()</code> method instead.
       * @param params parameters specific to the give upgradable type (all types require <code>level</code>)
       * 
       * @return cost of the given upgradable appropriately rounded. The value returned should not be rounded
       * or modified in the similar way further.
       * 
       * @see #calculateUpgradeTime()
       * 
       * @throws ArgumentErrror if given <code>resourceType<code> is not supported
       */
      public static function calculateCost(upgradableType:String,
                                           upgradableSubtype:String,
                                           resourceType:String,
                                           params:Object) : Number
      {
         if (resourceType == ResourceType.SCIENTISTS ||
             resourceType == ResourceType.TIME)
         {
            throw new ArgumentError("Resource type " + resourceType + " is not supported by this method");
         }
         try
         {
            return Math.ceil(evalUpgradableFormula(upgradableType, upgradableSubtype,
                                                   resourceType + ".cost", params));
         }
         // An upgradable may not have cost defined. In that case, the cost is 0. 
         catch (err:ArgumentError)
         {
            return 0;
         }
         return 0;   // unreachable
      }
      
      
      /**
       * Calculates upgrade time for the given upgradable.
       * 
       * @param upgradableType one of upgradable types in <code>UpgradableType</code>
       * @param upgradableSubtype subtype (type of unit, technology or building in most cases) of the upgradable
       * @param params parameters specific to the give upgradable type (all types require <code>level</code>)
       * @param constructionMod construction mod to use in the calculations. If not provided, construction mod
       * will not be included in the calculations
       * 
       * @return upgrade time in seconds
       */
      public static function calculateUpgradeTime(upgradableType:String,
                                                  upgradableSubtype:String,
                                                  params:Object,
                                                  constructionMod:Number = 0) : Number
      {
         var time:Number = evalUpgradableFormula(upgradableType, upgradableSubtype, "upgradeTime", params);
         time = Math.max(1, Math.floor (time * (Math.max((100 - constructionMod),
                                                         Config.getMinTimePercentage()) / 100)) );
         return time;
      }
      
      
      
      
      
      protected var parent:IUpgradableModel;
      
      
      public function Upgradable(parent:IUpgradableModel)
      {
         this.parent = parent;
      }
      
      
      protected function get upgradableType() : String
      {
         throw new IllegalOperationError("This method is abstract");
      }
      
      
      /**
       * Calculates and returns upgrade time of the model at a given level. If you don't provide
       * <code>level</code>, value of <code>parent.level</code> is used.
       * 
       * @return upgrade time in soconds 
       */
      public function calcUpgradeTime(params:Object) : Number
      {
         if (params.level == null)
         {
            params.level = level;
         }
         return calcUpgradeTimeImpl(params);
      }
      
      
      /**
       * Upgradable specific implementation of upgrade time calculation. Must return upgrade time measured
       * in seconds.
       */
      protected function calcUpgradeTimeImpl(params:Object) : Number
      {
         throw new IllegalOperationError("This method is abstract!");
      }
      
      
      private var _level:int = 0;
      [Bindable (event="levelChange")]
      public function get level() : int
      {
         return _level;
      }
      public function set level(value: int) : void
      {
         if (value != _level)
         {
            _level = value;
            dispatchLevelChangeEvent();
         }
      }
      
      
      public function enoughResourcesForNextLevel(ssObject:MSSObject) : Boolean
      {
         var resourcesNeeded:ResourcesAmount = resourcesNeededForNextLevel();
         return resourcesNeeded.metal  <= ssObject.metal.currentStock &&
                resourcesNeeded.energy <= ssObject.energy.currentStock &&
                resourcesNeeded.zetium <= ssObject.zetium.currentStock;
      }
      
      
      public function resourcesNeededForNextLevel() : ResourcesAmount
      {
         function calcCost(resourceType:String) : Number
         {
            return calculateCost(upgradableType, parent.type, resourceType, {"level": level + 1});
         }
         return new ResourcesAmount(
            calcCost(ResourceType.METAL),
            calcCost(ResourceType.ENERGY),
            calcCost(ResourceType.ZETIUM)
         );
      }
      
      
      public function timeNeededForNextLevel() : Number
      {
         return calcUpgradeTime({"level": level + 1});
      }
      
      
      [Bindable(event="upgradePropChange")]
      public function get timeToFinishString() : String
      {
         if (!upgradeCompleted)
         {
            return DateUtil.secondsToHumanString((_upgradeEndsAt.time - _lastUpdate.time)/1000);
         }
         else
         {
            return DateUtil.secondsToHumanString(0);
         }
      }
      
      [Bindable(event="upgradePropChange")]
      public function get timeToFinish() : Number
      {
         if (!upgradeCompleted)
         {
            return (_upgradeEndsAt.time - _lastUpdate.time) / 1000;
         }
         else
         {
            return 0;
         }
      }
      
      
      private var _lastUpdate:Date=null;
      [Bindable(event="upgradePropChange")]
      /**
       * Date and time when construction of a building has been updated.
       * This holds server time.
       * 
       * @default null
       */
      public function set lastUpdate(v:Date) : void
      {
         _lastUpdate = v;
         dispatchUpgradablePropChangeEvent();
      }
      public function get lastUpdate() : Date
      {
         return _lastUpdate;
      }
      
      
      private var _upgradeEndsAt: Date = null;
      [Bindable(event="upgradePropChange")]
      /**
       * Date and time when construction of a model will be completed.
       * This holds server time.
       * 
       * @default null
       */
      public function set upgradeEndsAt(v:Date) : void
      {
         _upgradeEndsAt = v;
         dispatchUpgradablePropChangeEvent();
      }
      public function get upgradeEndsAt() : Date
      {
         return _upgradeEndsAt;
      }
      
      
      /**
       * Time when upgrade of a model has been started.
       */
      public function get upgradeStarted() : Date
      {
         if (!upgradeEndsAt)
         {
            return null;
         }
         return new Date(upgradeEndsAt.time - calcUpgradeTime({"level": level + 1}) * 1000);
      };
      
      
      [Bindable(event="upgradePropChange")]
      /**
       * Indicates if upgrade process of this model has been completed
       * (<code>upgradeEndsAt &lt;= now || upgradeEndsAt == null</code>)
       */
      public function get upgradeCompleted() : Boolean
      {
         return (upgradeEndsAt == null || upgradeEndsAt.time <= new Date().time); 
      }
      
      
      /**
       * Forces this model to a upgrade completed state.
       * 
       * @param level New level of a model. If you won't provide this
       * the value, current level will be incremented by 1.
       */
      public function forceUpgradeCompleted(level:int = 0) : void
      {
         stopUpgrade();
         suppressUpgradablePropChangeEvent = true
         upgradeEndsAt = null;
         lastUpdate = null;
         if (level > 0)
         {
            this.level = level;
         }
         else
         {
            this.level++;
         }
         suppressUpgradablePropChangeEvent = false;
         dispatchUpgradablePropChangeEvent();
         dispatchUpgradeProgressEvent();
      }
      
      
      private var upgradeTimer:Timer = null;
      private function get upgradeTimerInitialized() : Boolean
      {
         return upgradeTimer != null;
      }
      private function initUpgradeTimer() : void
      {
         if (upgradeTimerInitialized)
            return;
         upgradeTimer = new Timer(1000);
         upgradeTimer.addEventListener(TimerEvent.TIMER, updateUpgradeProgress);
         upgradeTimer.start();
      }
      private function destroyUpgradeTimer() : void
      {
         upgradeTimer.stop();
         upgradeTimer.removeEventListener(TimerEvent.TIMER, updateUpgradeProgress);
         upgradeTimer = null;
      }
      
      
      private var fUpgradeProgressActive:Boolean = false;
      [Bindable(event="upgradeProgress")]
      /**
       * Use this to get value of upgrade progress (from 0 to 1).
       */
      public function get upgradeProgress() : Number
      {
         if (upgradeCompleted)
            return 1;
         
         var wholeProgress:Number = upgradeEndsAt.time - upgradeStarted.time;
         var currentProgress:Number = new Date().time - upgradeStarted.time;
         if (currentProgress < 0)
            currentProgress = 0;
         
         return currentProgress / wholeProgress;
      }
      
      
      /**
       * Call this to start the times that will update <code>upgradeProgress</code>
       * property during time.
       */
      public function startUpgrade() : void
      {
         if (! lastUpdate)
         {
            throw new Error("lastUpdate can't be null.");
         }
         fUpgradeProgressActive = true;
         initUpgradeTimer();
         dispatchUpgradeProgressEvent();
      }
      /**
       * Call this to resume the upgrade process. This acts similary to
       * <code>startUpgrade()</code> but does not set <code>upgradeStarted</code>
       * property. 
       */
      public function resumeUpgrade() : void
      {
         if (fUpgradeProgressActive)
            return;
         upgradeTimer.start();
         dispatchUpgradeProgressEvent();
      }
 
      /**
       * Use this to stop the timer that updates <code>upgradeProgress</code>
       * property.
       */
      public function stopUpgrade() : void
      {
         if (! fUpgradeProgressActive)
            return;
         destroyUpgradeTimer();
         fUpgradeProgressActive = false;
         dispatchStopEvent();
      }
      
      
      /**
       * Each second updates <code>upgradeProgress</code> property. Will stop upgrade process if
       * <code>upgradeCompleted</code> becomes <code>true</code>.
       */
      protected function updateUpgradeProgress(e:TimerEvent) : void
      {
         beforeUpgradeProgressUpdate(new Date().time);
         if (upgradeCompleted)
         {
            forceUpgradeCompleted();
         }
         else
         {
            lastUpdate = new Date();
            dispatchUpgradeProgressEvent();
         }
      };
      protected function beforeUpgradeProgressUpdate(timeNow:Number) : void
      {
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchLevelChangeEvent() : void
      {
         if (hasEventListener(UpgradeEvent.LVL_CHANGE))
         {
            dispatchEvent(new UpgradeEvent(UpgradeEvent.LVL_CHANGE));
         }
         if (parent.hasEventListener(UpgradeEvent.LVL_CHANGE))
         {
            parent.dispatchEvent(new UpgradeEvent(UpgradeEvent.LVL_CHANGE));
         }
      }
      
      private var suppressUpgradablePropChangeEvent:Boolean = false;
      private function dispatchUpgradablePropChangeEvent() : void
      {
         if (!suppressUpgradablePropChangeEvent && hasEventListener(UpgradeEvent.UPGRADE_PROP_CHANGE))
         {
            dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADE_PROP_CHANGE));
         }
      }
      
      private function dispatchUpgradeProgressEvent() : void
      {
         if (hasEventListener(UpgradeEvent.UPGRADE_PROGRESS))
         {
            dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADE_PROGRESS));
         }
      }
      
      private function dispatchStopEvent() : void
      {
         if (hasEventListener(UpgradeEvent.UPGRADE_STOPED))
         {
            dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADE_STOPED));
         }
      }
   }
}