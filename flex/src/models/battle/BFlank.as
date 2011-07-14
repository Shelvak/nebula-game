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
       * List of all buildings in this flank.
       */
      public var buildings:ModelsCollection = new ModelsCollection();
      
      /**
       * List of all ground units in this flank.
       */
      public var groundUnits:ModelsCollection = new ModelsCollection();
      
      
      /**
       * List of all space units in this flank.
       */
      public var spaceUnits:ModelsCollection = new ModelsCollection();
      
      
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
       * Indicates if there are buildings in this flank.
       */
      public function get hasBuildings() : Boolean
      {
         return !buildings.isEmpty;
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