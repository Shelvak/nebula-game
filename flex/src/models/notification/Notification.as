package models.notification
{
   import controllers.notifications.NotificationsCommand;
   
   import models.BaseModel;
   import models.notification.events.NotificationEvent;
   
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.ObjectUtil;
   
   
   [Event(name="readChange", type="models.notification.events.NotificationEvent")]
   [Event(name="starredChange", type="models.notification.events.NotificationEvent")]
   [Event(name="isnewChange", type="models.notification.events.NotificationEvent")]
   
   
   public class Notification extends BaseModel
   {
      private static function get logger() : ILogger {
         return Log.getLogger("models.notification.Notification");
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      [Bindable]
      [Required]
      public var event:int = -1;
      
      
      [Bindable(event="willNotChange")]
      public function get message() : String {
         try {
            return customPart.message;
         }
         catch (err:Error) {
            logger.error(
               "Reading customPart.message caused an error: {0}.\n" +
               "Notification model:\n{1}",
               err.message, ObjectUtil.toString(this)
            );
            throw err;
         }
         return null;   // unreachable
      }
      
      
      [Bindable(event="willNotChange")]
      public function get title() : String
      {
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
      public function set starred(value:Boolean) : void
      {
         if (_starred != value)
         {
            _starred = value;
            dispatchStarredChangeEvent();
            dispatchPropertyUpdateEvent("starred", value);
         }
      }
      public function get starred() : Boolean
      {
         return _starred;
      }
      
      
      private var _read:Boolean = false;
      [Bindable(event="readChange")]
      [Required]
      public function set read(value:Boolean) : void
      {
         if (_read != value)
         {
            _read = value;
            if (_read)
            {
               isNew = false;
            }
            dispatchReadChangeEvent();
            dispatchPropertyUpdateEvent("read", value);
         }
      }
      public function get read() : Boolean
      {
         return _read;
      }
      
      
      private var _isNew:Boolean = false;
      [Bindable(event="isNewChange")]
      [Optional]
      public function set isNew(value:Boolean) : void
      {
         if (_isNew != value)
         {
            _isNew = value;
            dispatchIsNewChangeEvent();
            dispatchPropertyUpdateEvent("isNew", value);
         }
      }
      public function get isNew() : Boolean
      {
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
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchStarredChangeEvent() : void
      {
         if (hasEventListener(NotificationEvent.STARRED_CHANGE))
         {
            dispatchEvent(new NotificationEvent(NotificationEvent.STARRED_CHANGE));
         }
      }
      
      
      private function dispatchReadChangeEvent() : void
      {
         if (hasEventListener(NotificationEvent.READ_CHANGE))
         {
            dispatchEvent(new NotificationEvent(NotificationEvent.READ_CHANGE));
         }
      }
      
      
      private function dispatchIsNewChangeEvent() : void
      {
         if (hasEventListener(NotificationEvent.ISNEW_CHANGE))
         {
            dispatchEvent(new NotificationEvent(NotificationEvent.ISNEW_CHANGE));
         }
      }
   }
}