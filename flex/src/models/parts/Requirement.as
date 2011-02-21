package models.parts
{
   import config.Config;
   
   import models.ModelLocator;
   import models.technology.Technology;
   
   public class Requirement
   {
      /**
       * checks if all requirements are met 
       * @param requirements, object of requirements
       * @return true if valid, false otherwise
       * 
       */      
      public static function isValid(requirements: Object): Boolean
      {
         for (var requirement: String in requirements)
         {           
            var tech: Technology = ModelLocator.getInstance().technologies.getTechnologyByType(requirement);
            if (tech == null)
            {
               /*
               These lines are reached only if technology was not found in tech list.
               There are two ways to encounter this:
               * Some technology is writen in requirements, but not in config.
               * Technologies list was cleaned after reconnect.
               THIS IS TEMPORARY AND NEEDS TO BE CHANGED
               2011.02.21
               */
               trace('Technology',requirement,'not found in config!');
            }
            if (requirements[requirement].invert)        
            {
               if (tech.level > 0 || tech.upgradePart.upgradeEndsAt != null)
                  return false;
            }
            if (tech.level < requirements[requirement].level) {
               return false;
            } 
         }
         
         return true;
      }
      
   }
}