package models.movement
{
   import flash.errors.IllegalOperationError;
   
   import models.Owner;
   import models.location.LocationMinimal;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
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
      
      
      public function findStationary(location:LocationMinimal, owner:int) : MSquadron
      {
         return findFirst(
            function(squad:MSquadron) : Boolean
            {
               return !squad.isMoving && squad.owner == owner;
            }
         );
      }
      
      
      public function findAllIn(location:LocationMinimal) : ArrayCollection
      {
         return new ArrayCollection(findAll(
            function(squad:MSquadron) : Boolean
            {
               return squad.currentHop.location.equals(location)
            }
         ));
      }
      
      
      public function findAll(testFunction:Function) : Array
      {
         var result:Array = new Array();
         for each (var squad:MSquadron in this)
         {
            if (testFunction(squad))
            {
               result.push(squad);
            }
         }
         return result;
      }
      
      
      public function findFirst(testFunction:Function) : MSquadron
      {
         var result:Array = findAll(testFunction);
         return result.length > 0 ? result[0] : null;
      }
      
      
      public function removeSquadron(squad:MSquadron) : MSquadron
      {
         return MSquadron(removeItemAt(getItemIndex(squad)));
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