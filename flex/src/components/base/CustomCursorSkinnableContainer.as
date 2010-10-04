package components.base
{
   public class CustomCursorSkinnableContainer
      extends BaseSkinnableContainer
      implements ICursorChanger
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