package models.parts
{
   import config.Config;
   
   import models.ModelLocator;
   
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
            if (requirements[requirement].invert)        
            {
               if (ModelLocator.getInstance().technologies.getTechnologyByType(requirement).level > 0)
                  return false;
            }
            if (ModelLocator.getInstance().technologies.getTechnologyByType(requirement).level
               < requirements[requirement].level) {
               return false;
            } 
         }
         
         return true;
      }
      
   }
}