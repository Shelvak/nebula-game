package components.base
{
   import spark.components.Group;
   
   public class BaseContainer extends Group
   {
      include "mixins/singletonProperties.as";
      include "mixins/defaultModelPropImpl.as";
      
      /**
       * Constructor. 
       */      
      public function BaseContainer ()
      {
         minWidth = 0;
         minHeight = 0;
      }
   }
}