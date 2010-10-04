package models.battle
{
   import models.BaseModel;
   import models.ModelsCollection;

   public class BFlank extends BaseModel
   {
      //flank cells to free x positions in matrix 
      //use {start: before offset, end: after offset}
      public var cellsToFree: Object = {'start': null, 'end': null};
	  
      public var flankStart: int = 0;
      public var flankEnd: int = 0;
      public var placeFinder: PlaceFinder;
	  
	  public var flankNr: int;
     
     
     /**
      * for units placement optimization
      */      
     public var unitsStartHash: Object = {};
     
      /**
       * 
       * @return if there are still some units in this flank with hp > 0
       * 
       */      
      public function hasAliveUnits(): Boolean
      {
         for each (var gUnit: BUnit in groundUnits)
         if (gUnit.hp > 0) return true;
         
         for each (var sUnit: BUnit in spaceUnits)
         if (sUnit.hp > 0) return true;
         
         return false;
      }
      
      /**
       * List of all ground units in this flank.
       */
      public var groundUnits:ModelsCollection = new ModelsCollection();
      
      
      /**
       * List of all space units in this flank.
       */
      public var spaceUnits:ModelsCollection = new ModelsCollection();
      
      public function getAllUnits(): ModelsCollection
      {
         var allUnits: ModelsCollection = new ModelsCollection();
         allUnits.addAll(groundUnits);
         allUnits.addAll(spaceUnits);
         return allUnits;
      }
      
      /**
       * Adds a given unit to appropriate units list.
       * 
       * @param unit a unit to add to the list of units. <code>null</code> will cause an error
       * @param kind air or ground unit (use constants in <code>BUnitKind</code> class)
       */
      public function addUnit(unit:BUnit, kind:String) : void
      {
         var unitsList:ModelsCollection = null;
         switch (kind)
         {
            case BUnitKind.SPACE:
               unitsList = spaceUnits;
               break;
            case BUnitKind.GROUND:
               unitsList = groundUnits;
               break;
         }
         unitsList.addItem(unit);
      }
      
      
      /**
       * Removes unit with a given id from this flank. This method assumes that all units
       * have unique values of <code>id</code> property.
       * 
       * @param id id of a unit to remove
       * 
       * @return a unit which has been removed or <code>null</code> if nothing has been removed
       */
      public function removeUnitWithId(id:int) : BUnit
      {
         var unitsList:ModelsCollection = groundUnits;
         var unitToRemove:BUnit = BUnit(groundUnits.findModel(id));
         if (!unitToRemove)
         {
            unitsList = spaceUnits;
            unitToRemove = BUnit(spaceUnits.findModel(id));
         }
         return BUnit(unitsList.removeItem(unitToRemove));
      }
      
      
      /**
       * Removes given unit form units list.
       * 
       * @param unit a unit to remove
       * 
       * @return instance of <code>BUnit</code> which has been removed or <code>null</code> if
       * nothing has been removed
       */
      public function removeUnit(unit:BUnit) : BUnit
      {
         return removeUnitWithId(unit.id);
      }
      
      
      /**
       * Indicates if there are ground units in this flank.
       */
      public function get hasGroundUnits() : Boolean
      {
         return !groundUnits.isEmpty;
      }
      
      
      /**
       * Indicates if there are space units in this flank.
       */
      public function get hasSpaceUnits() : Boolean
      {
         return !spaceUnits.isEmpty;
      }
      
      
      /**
       * Indicates if there are any units in this flank left.
       */
      public function get hasUnits() : Boolean
      {
         return hasGroundUnits || hasSpaceUnits;
      }
      
      public function getUnitById(id: int): BaseModel
      {
         if (groundUnits.findModel(id) != null)
            return groundUnits.findModel(id)
         else
         if (spaceUnits.findModel(id) != null)
            return spaceUnits.findModel(id);
         return null;
      }
   }
}