package components.base
{
   import mx.events.FlexEvent;
   
   
   public class AdvancedSkinnableContainer extends BaseContainer
   {
      include "mixins/AdvancedContainerImpl.as";
      
      
      public function AdvancedSkinnableContainer()
      {
         addEventListener(FlexEvent.CREATION_COMPLETE, advCont_creationCompleteHandler);
         super();
      }
   }
}