/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/21/12
 * Time: 11:59 AM
 * To change this template use File | Settings | File Templates.
 */
package models.notification {
   import controllers.notifications.EventsController;

   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   import models.ModelLocator;

   import utils.assets.AssetNames;

   import utils.assets.ImagePreloader;

   public class MEvent {

      public static const INACTIVE_CONTENT_ALPHA: Number = 0.4;

      public var id: int;

      [Bindable]
      public var message: String;

      /* time to be shown, 0 means it won't hide itself */
      public var duration: int;

      [Bindable (event="willNotChange")]
      public function get image(): BitmapData
      {
         throw new Error('This method is abstract!');
      }

      protected function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }

      protected function get IMG(): ImagePreloader
      {
         return ImagePreloader.getInstance();
      }

      protected function get EC(): EventsController
      {
         return EventsController.getInstance();
      }

      [Bindable (event="WillNotChange")]
      public function get rendererAlpha(): Number
      {
         return 1;
      }

      public function clickHandler(event:MouseEvent): void
      {
         //override this function to implement any action
      }

      public function MEvent(_message: String, _duration: int = 0) {
         message = _message;
         duration = _duration;
         id = EC.addEvent(this);
      }
   }
}
