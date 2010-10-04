package utils
{
   public class NameResolver
   {
      private static const SOLAR_SYSTEM_NAMES:Array = ["Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", 
         "Eta", "Theta", 
         "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", 
         "Upsilon", "Phi", "Chi", "Psi", "Omega"];

      
      public static function resolve(list: Array, value: int): String
      {
         var iteration: int = (value - 1) / list.length;
         var index: int = value - iteration * list.length - 1;
         return list[index] + "-" + (iteration + 1).toString ()
      }
      
      public static function resolveSolarSystem(value: int): String
      {
         return resolve(SOLAR_SYSTEM_NAMES, value);
      }
   }
}