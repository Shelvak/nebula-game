package models.announcement
{
   import interfaces.IUpdatable;
   
   import models.BaseModel;
   import models.time.MTimeEventFixedMoment;
   
   import namespaces.change_flag;
   import namespaces.prop_name;
   
   import utils.SingletonFactory;
   
   
   /**
    * @see models.announcement.MAnnouncementEvent#BUTTON_VISIBLE_CHANGE
    * @eventType models.announcement.MAnnouncementEvent.BUTTON_VISIBLE_CHANGE
    */
   [Event(name="buttonVisibleChange", type="models.announcement.MAnnouncementEvent")]
   
   /**
    * @see models.announcement.MAnnouncementEvent#RESET
    * @eventType models.announcement.MAnnouncementEvent.RESET
    */
   [Event(name="reset", type="models.announcement.MAnnouncementEvent")]
   
   /**
    * Announcement model singleton.
    */
   public class MAnnouncement extends BaseModel implements IUpdatable
   {
      public static function getInstance() : MAnnouncement {
         return SingletonFactory.getSingletonInstance(MAnnouncement);
      }
      
      
      public function MAnnouncement() {
         super();
      }
      
      public function reset() : void {
         this.message = null;
         this.event.occuresAt = new Date(0);
         dispatchAnnouncmentEvent(MAnnouncementEvent.RESET);
      }
      
      prop_name static const message:String = "message";
      [Bindable]
      public var message:String;
      
      [Bindable(event="willNotChange")]
      public const event:MTimeEventFixedMoment = new MTimeEventFixedMoment();
      
      
      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */
      
      public function update() : void {
         event.update();
         if (event.change_flag::hasOccured)
            dispatchAnnouncmentEvent(MAnnouncementEvent.BUTTON_VISIBLE_CHANGE);
      }
      
      public function resetChangeFlags() : void {
         event.resetChangeFlags();
      }
      
      
      /* ########## */
      /* ### UI ### */
      /* ########## */
      
      [Bindable(event="buttonVisibleChange")]
      public function get buttonVisible() : Boolean {
         return !event.hasOccured;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function dispatchAnnouncmentEvent(type:String) : void {
         dispatchSimpleEvent(MAnnouncementEvent, type);
      }
   }
}