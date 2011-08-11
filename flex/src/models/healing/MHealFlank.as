package models.healing
{
   import models.ModelsCollection;
   import models.Owner;
   import models.unit.UnitsFlank;
   
   import mx.collections.ListCollectionView;
   
   public class MHealFlank extends UnitsFlank
   {
      public function MHealFlank(_flank:ListCollectionView, 
                                 _nr:int, _owner:int=Owner.PLAYER, 
                                 _selectionClass: HealingSelection = null)
      {
         super(_nr, _owner);
         flankUnits = _flank;
         selectionClass = _selectionClass;
      }
      
      public var selectionClass: HealingSelection;
   }
}