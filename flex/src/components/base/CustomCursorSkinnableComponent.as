package components.base
{
   import utils.assets.Cursors;
   
   import flash.events.MouseEvent;

   /**
    * Skinnable component that will change mouse cursor to a custom image when mouse
    * moves over it and will restore default system cursor when mouse pointer
    * leaves area of the container.
    */
   [Bindable]
   public class CustomCursorSkinnableComponent
      extends BaseSkinnableComponent
      implements ICursorChanger
   {
      include "mixins/defaultICursorChangerImpl.as";
      /**
       * Constructor. 
       */
      public function CustomCursorSkinnableComponent()
      {
         super ();
         include "mixins/ICursorChangerListenersRegistration.as";
      }
   }
}