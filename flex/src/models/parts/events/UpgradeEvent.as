package models.parts.events
{
   import flash.events.Event;
   
   
   public class UpgradeEvent extends Event
   {
      /**
       * Dispached when <code>level</code> property changes.
       * 
       * @eventType levelChange
       */
      public static const LVL_CHANGE:String="levelChange";
      
      /**
       * Dispached when <code>hpMax</code> property changes.
       * 
       * @eventType hpMaxChange
       */
      public static const HP_MAX_CHANGE:String="hpMaxChange";
      
      /**
       * Dispatched when <code>upgradeStarted, upgradeEnds</code> or
       * <code>upgradeUpdatedAt</code> properties change. As a result of this
       * <code>upgradeCompleted</code> also changes.
       * 
       * @eventType upgradePropChange
       */
      public static const UPGRADE_PROP_CHANGE:String = "upgradePropChange";
      
      /**
       * Dispatched when upgrade is paused.
       * 
       * @eventType upgradeStoped
       */
      public static const UPGRADE_STOPED:String = "upgradeStoped";
      
      /**
       * Dispatched when <code>upgradeProgress</code> property changes.
       * 
       * @eventType upgradeProgress
       */
      public static const UPGRADE_PROGRESS:String = "upgradeProgress";
      
      /**
      * Dispatched then uograde of the model finishes,
      * since building upgrade finished requires properties, it uses diferent event,
      * this one is used for technology model for now
      * 
      * @eventType upgradeFinished
      */
      public static const UPGRADE_FINISHED:String = "upgradeFinished";
      
      
      public function UpgradeEvent(type:String)
      {
         super(type, false, false);
      }
   }
}