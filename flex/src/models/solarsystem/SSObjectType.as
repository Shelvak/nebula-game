package models.solarsystem
{
   import utils.Localizer;

   
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
         return Localizer.string("SSObjects", "type." + type);
      }
   }
}