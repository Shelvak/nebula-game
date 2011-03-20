package components.location
{
   import controllers.Messenger;
   
   import flash.events.MouseEvent;
   
   import models.location.Location;
   
   import spark.components.Button;
   
   import utils.locale.Localizer;
   
   
   /**
    * A button which can navigate to a given location.
    */
   public class CLocationButton extends Button
   {
      /**
       * Location this button has to navigate to.
       */
      public var location:Location = null;
      
      
      /**
       * An object which should be selected after location has been opened.
       */
      public var zoomObject:* = null;
      
      
      public function CLocationButton()
      {
         super();
         addEventListener(MouseEvent.CLICK, this_clickHandler);
         label = Localizer.string('Location', 'label.open');
      }
      
      
      private function this_clickHandler(event:MouseEvent) : void
      {
         if (location.isNavigable)
         {
            location.navigateTo(zoomObject);
         }
         else
         {
            Messenger.show(Localizer.string("Location", "message.locationNotAvailable"), Messenger.SHORT);
         }
      }
   }
}