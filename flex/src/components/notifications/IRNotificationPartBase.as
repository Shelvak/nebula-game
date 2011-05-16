package components.notifications
{
   import flash.events.MouseEvent;
   
   import models.BaseModel;
   import models.notification.INotificationPart;
   
   import spark.components.Button;
   import spark.components.supportClasses.SkinnableComponent;
   
   import utils.Objects;
   
   
   public class IRNotificationPartBase extends SkinnableComponent implements IIRNotificationPart
   {
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      public function IRNotificationPartBase()
      {
         super();
         left=0;
         right=0;
      }
      
      /**
       * Indicates if <code>notificationPart</code> has been changed set this to <code>false</code>
       * in <code>commitProperies()</code> if you use this property.
       */
      protected var f_NotificationPartChange:Boolean = false;
      
      
      private var _notificationPart:INotificationPart = null;
      /**
       * Instance of <code>INotificationPart</code> used as data provider. This is guaranteed not to
       * be <code>null</code> if <code>fNotificationPartSet == true</code>
       */
      protected function get notificationPart() : INotificationPart
      {
         return _notificationPart;
      }
      
      
      public function setNotificationPart(value:INotificationPart) : void
      {
         Objects.paramNotNull("value", value);
         if (value != _notificationPart)
         {
            _notificationPart = value;
            f_NotificationPartChange = true;
            invalidateProperties();
         }
      }
   }
}