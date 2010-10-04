package components.base
{
   import spark.components.Panel;
   
   
   public class Panel extends spark.components.Panel
   {
      include "mixins/singletonProperties.as";
      include "mixins/defaultModelPropImpl.as";
      
      /**
       * Contructor.
       */
      public function Panel()
      {
         super();
         minWidth = 20;
         minHeight = 20;
      }
   }
}
