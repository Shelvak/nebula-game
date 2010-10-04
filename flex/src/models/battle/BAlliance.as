package models.battle
{
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Player;
   
   
   /**
    * An aliance which participated in battle, has flanks of mixed teammates
    */
   public class BAlliance extends Player
   {
      public var flanks:ModelsCollection = new ModelsCollection();
      
      /**
       * 
       * @param id
       * @return BUnit if found in flanks, null if not
       * 
       */      
      public function getUnitById(id: int): BaseModel
      {
         for each (var flank: BFlank in flanks)
         {
            if (flank.getUnitById(id) != null)
               return flank.getUnitById(id);
         }
         return null;
      }
      
      public function get hasUnits() : Boolean
      {
         for each (var flank:BFlank in flanks)
         {
            if (flank.hasUnits)
            {
               return true;
            }
         }
         return false;
      }
      
      /**
       * for sorting reasons in BattleMap 
       */      
      public var status: int = -1;
   }
}