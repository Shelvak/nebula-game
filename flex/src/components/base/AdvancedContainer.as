package components.base
{
   import mx.events.FlexEvent;
   
   
   public class AdvancedContainer extends BaseContainer
   {
      include "mixins/advancedContainerImpl.as";
      
      
      public function AdvancedContainer()
      {
         addEventListener(FlexEvent.CREATION_COMPLETE, advCont_creationCompleteHandler);
         super();
      }
   }
}
