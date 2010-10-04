package components.base
{
   import spark.components.SkinnableContainer;
   
   public class BaseSkinnableContainer extends SkinnableContainer
   {
      include "mixins/singletonProperties.as";
      include "mixins/defaultModelPropImpl.as";
      
      /**
       * Contructor.
       */ 
      public function BaseSkinnableContainer()
      {
         super();
         minWidth = 0;
         minHeight = 0;
      }
   }
}