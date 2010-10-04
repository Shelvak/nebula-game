package components.base
{
   import spark.skins.SparkSkin;
   
   public class BaseSkin extends SparkSkin
   {
      include "mixins/singletonProperties.as";
      
      
      /**
       * Constructor. 
       */
      public function BaseSkin()
      {
         mouseEnabled = false;
      }
   }
}