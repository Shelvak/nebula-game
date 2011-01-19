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
               throw new Error('Technology ' + requirement + ' not found in config!');
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