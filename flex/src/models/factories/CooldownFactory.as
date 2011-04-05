package models.factories
{
   import models.BaseModel;
   import models.cooldown.MCooldown;
   import models.cooldown.MCooldownSpace;
   
   
   public class CooldownFactory
   {
      public static function MCooldown_fromObject(o:Object) : MCooldown
      {
         return BaseModel.createModel(MCooldown, o);
      }
      
      
      public static function MCooldownSpace_fromObject(o:Object) : MCooldownSpace
      {
         return BaseModel.createModel(MCooldownSpace, o);
      }
   }
}