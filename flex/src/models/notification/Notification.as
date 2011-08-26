package models.notification
{
   import controllers.notifications.NotificationsCommand;
   
   import models.BaseModel;
   import models.location.ILocationUser;
   import models.notification.events.NotificationEvent;
   
   
   /**
    * @see models.notification.events.NotificationEvent#READ_CHANGE
    */
   [Event(name="readChange", type="models.notification.events.NotificationEvent")]
   
   /**
    * @see models.notification.events.NotificationEvent#STARRED_CHANGE
    */
   [Event(name="starredChange", type="models.notification.events.NotificationEvent")]
   
   /**
    * @see models.notification.events.NotificationEvent#IS_NEW_CHANGE
    */
   [Event(name="isNewChange", type="models.notification.events.NotificationEvent")]
   
   /**
    * @see models.notification.events.NotificationEvent#MESSAGE_CHANGE_CHANGE
    */
   [Event(name="messageChange", type="models.notification.events.NotificationEvent")]
   
   
   public class Notification extends BaseModel implements ILocationUser
   {
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      [Bindable]
      [Required]
      public var event:int = -1;
      
      [Bindable(event="messageChange")]
      public function get message() : String {
         return customPart.message;
      }
      
      [Bindable(event="willNotChange")]
      public function get title() : String {
         return customPart.title;
      }
      
      [Bindable]
      [Required]
      public var params:Object = null;
      
      [Bindable]
      [Required]
      public var createdAt:Date;
      
      [Bindable]
      [Required]
      public var expiresAt:Date;
      
      private var _starred:Boolean = false;
      [Bindable(event="starredChange")]
      [Required]
      public function set starred(value:Boolean) : void {
         if (_starred != value) {
            _starred = value;
            dispatchNotificationEvent(NotificationEvent.STARRED_CHANGE);
            dispatchPropertyUpdateEvent("starred", value);
         }
      }
      public function get starred() : Boolean {
         return _starred;
      }
      
      private var _read:Boolean = false;
      [Bindable(event="readChange")]
      [Required]
      public function set read(value:Boolean) : void {
         if (_read != value) {
            _read = value;
            if (_read)
               isNew = false;
            dispatchNotificationEvent(NotificationEvent.READ_CHANGE);
            dispatchPropertyUpdateEvent("read", value);
         }
      }
      public function get read() : Boolean {
         return _read;
      }
      
      private var _isNew:Boolean = false;
      [Bindable(event="isNewChange")]
      [Optional]
      public function set isNew(value:Boolean) : void {
         if (_isNew != value) {
            _isNew = value;
            dispatchNotificationEvent(NotificationEvent.IS_NEW_CHANGE);
            dispatchPropertyUpdateEvent("isNew", value);
         }
      }
      public function get isNew() : Boolean {
         return _isNew;
      }
      
      
      [Bindable]
      public var customPart:INotificationPart = null;
      
      
      /* ######################## */
      /* ### INTERFACE MTHODS ### */
      /* ######################## */
      
      
      public function doRead() : void
      {
         if (!read)
         {
            new NotificationsCommand(NotificationsCommand.READ, {"notifications": [this]}).dispatch();
         }
      }
      
      
      public function doStar(mark:Boolean) : void
      {
         if (starred != mark)
         {
            new NotificationsCommand(NotificationsCommand.STAR, {"notification": this, "mark": mark}).dispatch();
         }
      }
      
      
      /* ##################### */
      /* ### ILocationUser ### */
      /* ##################### */
      
      public function updateLocationName(id:int, name:String) : void {
         if  (customPart != null) {
            customPart.updateLocationName(id, name);
            dispatchNotificationEvent(NotificationEvent.MESSAGE_CHANGE);
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      public override function afterCreate(data:Object) : void
      {
         createCustomPart();
      }
      
      
      protected override function afterCopyProperties(source:BaseModel, props:Array) : void
      {
         createCustomPart();
      }
      
      
      private function createCustomPart() : void
      {
         if (event == -1 || params == null)
         {
            return;
         }
         customPart = NotificationPartFactory.createPart(this);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function dispatchNotificationEvent(type:String) : void {
         dispatchSimpleEvent(NotificationEvent, type);
      }
   }
}