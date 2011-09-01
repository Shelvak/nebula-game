package models.announcement
{
   import flashx.textLayout.elements.TextFlow;
   
   import interfaces.IUpdatable;
   
   import models.BaseModel;
   import models.time.MTimeEventFixedMoment;
   
   import namespaces.change_flag;
   
   import spark.utils.TextFlowUtil;
   
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
    * @see models.announcement.MAnnouncementEvent#MESSAGE_CHANGE
    * @eventType models.announcement.MAnnouncementEvent.MESSAGE_CHANGE
    */
   [Event(name="messageChange", type="models.announcement.MAnnouncementEvent")]
   
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
         _message = null;
         _messageTextFlow = null;
         event.occuresAt = new Date(0);
         dispatchAnnouncmentEvent(MAnnouncementEvent.RESET);
      }
      
      
      private var _message:String = null;
      [Bindable(event="messageChange")]
      public function set message(value:String) : void {
         if (_message != value) {
            _message = value;
            _messageTextFlow = TextFlowUtil.importFromString(value);
            dispatchAnnouncmentEvent(MAnnouncementEvent.MESSAGE_CHANGE);
         }
      }
      public function get message() : String {
         return _message;
      }
      
      private var _messageTextFlow:TextFlow = null;
      [Bindable(event="messageChange")]
      public function get messageTextFlow() : TextFlow {
         return _messageTextFlow;
      }
      
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