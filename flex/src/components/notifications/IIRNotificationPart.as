package components.notifications
{
   import models.notification.INotificationPart;
   
   import mx.core.IVisualElement;
   
   public interface IIRNotificationPart extends IVisualElement
   {
      /**
       * Sets notification part to be used as data provider
       * for this <code>IRINotificationPart</code>. This should be called only once
       * for the same instance of <code>IRINotificationPart</code>. Any subsequent
       * calls should cause an error.
       */
      function setNotificationPart(value:INotificationPart) : void;
   }
}