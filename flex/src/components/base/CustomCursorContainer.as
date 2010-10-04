package components.base
{
   import flash.events.MouseEvent;
   
   
   
   
   /**
    * Container that will change mouse cursor to a custom image when mouse
    * moves over it and will restore default system cursor when mouse pointer
    * leaves area of the container.
    */
   [Bindable]
   public class CustomCursorContainer extends BaseContainer implements ICursorChanger
   {
      include "mixins/defaultICursorChangerImpl.as";
      /**
       * Constructor. 
       */
      public function CustomCursorContainer ()
      {
         super ();
         include "mixins/ICursorChangerListenersRegistration.as";
      }
   }
}