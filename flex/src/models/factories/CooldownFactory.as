package models.factories
{
   import models.cooldown.MCooldown;
   import models.cooldown.MCooldownSpace;
   
   import utils.Objects;
   
   
   public class CooldownFactory
   {
      public static function MCooldown_fromObject(o:Object) : MCooldown {
         return Objects.create(MCooldown, o);
      }
      
      public static function MCooldownSpace_fromObject(o:Object) : MCooldownSpace {
         return Objects.create(MCooldownSpace, o);
      }
   }
}