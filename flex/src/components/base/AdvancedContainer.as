package components.base
{
   public class AdvancedContainer extends BaseContainer
   {
      include "mixins/advancedContainerImpl.as";
      
      
      public function AdvancedContainer()
      {
         super();
         addAdvContCreationCompleteHandler();
      }
   }
}
