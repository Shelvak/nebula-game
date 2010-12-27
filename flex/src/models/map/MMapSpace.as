package models.map
{
   import flash.errors.IllegalOperationError;
   
   import models.IStaticSpaceSectorObject;
   import models.StaticSpaceObjectsAggregator;
   import models.location.LocationMinimal;
   
   import utils.datastructures.Collections;

   public class MMapSpace extends MMap
   {
      public function MMapSpace()
      {
         super();
      }
      
      
      public function addStaticObject(object:IStaticSpaceSectorObject) : *
      {
         var aggregator:StaticSpaceObjectsAggregator = findAggregatorIn(object.currentLocation);
         if (aggregator)
         {
            aggregator.addItem(object);
         }
         else
         {
            aggregator = new StaticSpaceObjectsAggregator();
            aggregator.addItem(object);
            objects.addItem(aggregator);
         }
         return object;
      }
      
      
      public function removeStaticObject(object:IStaticSpaceSectorObject) : *
      {
         var aggregator:StaticSpaceObjectsAggregator = findAggregatorIn(object.currentLocation);
         aggregator.removeItemAt(aggregator.getItemIndex(object));
         if (aggregator.length == 0)
         {
            objects.removeItemAt(objects.getItemIndex(aggregator));
         }
         return object;
      }
      
      
      public function addStaticObjectsAggregator(aggregator:StaticSpaceObjectsAggregator) : StaticSpaceObjectsAggregator
      {
         var existingAggregator:StaticSpaceObjectsAggregator = findAggregatorIn(aggregator.currentLocation);
         if (existingAggregator)
         {
            throw new IllegalOperationError("Another aggregator " + existingAggregator + " already occupies " +
                                            "the same sector as the new aggregator " + aggregator);
         }
         objects.addItem(aggregator);
         return aggregator;
      }
      
      
      public function removeStaticObjectsAggregator(aggregator:StaticSpaceObjectsAggregator) : StaticSpaceObjectsAggregator
      {
         objects.removeItemAt(objects.getItemIndex(aggregator));
         return aggregator;
      }
      
      
      /* ######################################### */
      /* ### OBJECTS AGGREGATOR EVENT HANDLERS ### */
      /* ######################################### */
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function findAggregatorIn(location:LocationMinimal) : StaticSpaceObjectsAggregator
      {
         return Collections.findFirst(objects,
            function(aggr:StaticSpaceObjectsAggregator) : Boolean
            {
               return aggr.currentLocation.equals(location);
            }
         );
      }
   }
}