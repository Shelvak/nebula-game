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
         var source:Array = new Array();
         var item:Object;
         for each (item in groundUnits) source.push(item);
         for each (item in spaceUnits)  source.push(item);
         return new ModelsCollection(source);
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
         var unitToRemove:BUnit = BUnit(groundUnits.find(id));
         if (!unitToRemove)
         {
            unitsList = spaceUnits;
            unitToRemove = BUnit(spaceUnits.find(id));
         }
         return BUnit(unitsList.removeExact(unitToRemove));
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
         if (groundUnits.find(id) != null)
            return groundUnits.find(id)
         else
         if (spaceUnits.find(id) != null)
            return spaceUnits.find(id);
         return null;
      }
   }
}