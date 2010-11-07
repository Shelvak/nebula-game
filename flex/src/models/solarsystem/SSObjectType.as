package models.solarsystem
{
   import mx.resources.ResourceManager;

   [ResourceBundle("SSObjects")]
   public class SSObjectType
   {
      public static const PLANET:String = "Planet";
      public static const ASTEROID:String = "Asteroid";
      public static const JUMPGATE:String = "Jumpgate";
      
      
      /**
       * Returns a localized name of the given solar system object type.
       */
      public static function getLocalizedName(type:String) : String
      {
         return ResourceManager.getInstance().getString("SSObjects", "type." + type);
      }
   }
}