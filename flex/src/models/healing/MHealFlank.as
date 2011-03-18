package models.healing
{
   import models.ModelsCollection;
   import models.Owner;
   import models.unit.UnitsFlank;
   
   public class MHealFlank extends UnitsFlank
   {
      public function MHealFlank(_flank:ModelsCollection, _nr:int, _owner:int=Owner.PLAYER, 
                                 _selectionClass: HealingSelection = null)
      {
         super(_flank, _nr, _owner);
         selectionClass = _selectionClass;
      }
      
      public var selectionClass: HealingSelection;
   }
}