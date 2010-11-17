package models.movement
{
   import flash.errors.IllegalOperationError;
   
   import models.Owner;
   import models.location.LocationMinimal;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   
   import utils.datastructures.Collections;
   
   /**
    * List of <code>MSquadron</code>s with special lookup functions. It aggregates all squadrons in
    * all maps (stationary and moving) in one place.
    */
   public class SquadronsList extends ArrayCollection
   {
      public function SquadronsList(source:Array = null)
      {
         super(source);
      }
      
      
      public function findMoving(id:int) : MSquadron
      {
         return findFirst(
            function(squad:MSquadron) : Boolean
            {
               return squad.isMoving && squad.id == id;
            }
         );
      }
      
      /**
       *
       * finds squadron, this unit belongs to, and removes unit.
       * returns squadron 
       * @param unitId id of unit to be removed
       * 
       */      
      public function removeUnit(unitId: int): MSquadron
      {
         var squad: MSquadron = findFirst(
            function(squad:MSquadron) : Boolean
            {
               return (squad.units.find(unitId) != null);
            }
         );
         squad.units.remove(unitId);
         return squad;
      }
      
      /**
       *
       * finds squadron, this unit belongs to, and updates unit.
       * returns squadron 
       * @param unit unit to be removed
       * 
       */ 
      public function updateUnit(unit: Unit): MSquadron
      {
         var squad: MSquadron = findFirst(
            function(squad:MSquadron) : Boolean
            {
               return (squad.units.find(unit.id) != null);
            }
         );
         squad.units.addItem(unit);
         return squad;
      }
      
      
      public function findStationary(location:LocationMinimal, owner:int) : MSquadron
      {
         return findFirst(
            function(squad:MSquadron) : Boolean
            {
               return !squad.isMoving &&
               squad.owner == owner &&
               squad.currentHop.location.equals(location);
            }
         );
      }
      
      
      public function findAllIn(location:LocationMinimal) : ListCollectionView
      {
         return findAll(
            function(squad:MSquadron) : Boolean
            {
               return squad.currentHop.location.equals(location)
            }
         );
      }
      
      
      public function findAll(testFunction:Function) : ListCollectionView
      {
         return Collections.filter(this, testFunction);
      }
      
      
      public function findFirst(testFunction:Function) : MSquadron
      {
         return Collections.findFirst(this, testFunction);
      }
      
      
      public function removeSquadron(squad:MSquadron) : MSquadron
      {
         return Collections.removeFirstEqualTo(this, squad);
      }
      
      
      /* ########################################## */
      /* ### UNSUPPORTED METHODS AND PROPERTIES ### */
      /* ########################################## */
      
      
      public override function refresh() : Boolean
      {
         return throwFilterAndSortNotSupportedError();
      }
      
      
      public override function set filterFunction(f:Function) : void
      {
         throwFilterAndSortNotSupportedError();
      }
      
      
      public override function set sort(s:Sort) : void
      {
         throwFilterAndSortNotSupportedError();
      }
      
      
      private function throwFilterAndSortNotSupportedError() : *
      {
         throw new IllegalOperationError(
            "Filter and sort are not supported. Use ListCollectionView bound to this collection " +
            "of squadrons and ally filter and sort to it."
         );
         return void;
      }
   }
}