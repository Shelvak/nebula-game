package utils
{
   public class NameResolver
   {
      private static const SOLAR_SYSTEM_NAMES:Array = ["Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", 
         "Eta", "Theta", 
         "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", 
         "Upsilon", "Phi", "Chi", "Psi", "Omega"];
      
      private static const JUMPGATE_NAMES:Array = SOLAR_SYSTEM_NAMES;
      private static const ASTEROID_NAMES:Array = SOLAR_SYSTEM_NAMES;

      
      public static function resolve(list: Array, value: int): String
      {
         var iteration: int = (value - 1) / list.length;
         var index: int = value - iteration * list.length - 1;
         if (list[index] == null && list[index] == undefined)
         {
            throw new Error("Names resolver could not resolve solar system with id: "+value);
         }
         return list[index] + "-" + (iteration + 1).toString ()
      }
      
      public static function resolveSolarSystem(value: int): String
      {
         return resolve(SOLAR_SYSTEM_NAMES, value);
      }
      
      public static function resolveAsteroid(value: int): String
      {
         return resolve(ASTEROID_NAMES, value);
      }
      
      public static function resolveJumpgate(value: int): String
      {
         return resolve(JUMPGATE_NAMES, value);
      }
   }
}