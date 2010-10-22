package models.movement
{
   import models.Owner;
   import models.location.LocationMinimal;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   
   import utils.datastructures.Collections;
   
   /**
    * List of <code>MSquadron</code>s with special lookup functions. It aggregates all squadrons in
    * all maps (stationary and moving) in one place.
    */
   public class SquadronsList extends ArrayList
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
               squad.isMoving && squad.id == id;
            }
         );
      }
      
      
      public function findStationary(location:LocationMinimal, owner:Owner) : MSquadron
      {
         return findFirst(
            function(squad:MSquadron) : Boolean
            {
               !squad.isMoving && squad.owner == owner;
            }
         );
      }
      
      
      public function findAllIn(location:LocationMinimal) : ArrayCollection
      {
         return new ArrayCollection(findAll(
            function(squad:MSquadron) : Boolean
            {
               squad.currentHop.location.equals(location)
            }
         ));
      }
      
      
      private function findAll(testFunction:Function) : Array
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
      
      
      private function findFirst(testFunction:Function) : MSquadron
      {
         var result:Array = findAll(filterFunction);
         return result.length > 0 ? result[0] : null;
      }
   }
}