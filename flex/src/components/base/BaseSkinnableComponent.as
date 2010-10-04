package components.base
{
	import spark.components.supportClasses.SkinnableComponent;
	
	public class BaseSkinnableComponent extends SkinnableComponent
   {
      include "mixins/singletonProperties.as";
      include "mixins/defaultModelPropImpl.as";
      
      /**
       * Contructor.
       */
      public function BaseSkinnableComponent ()
      {
         minWidth = 0;
         minHeight = 0;
      }
	}
}