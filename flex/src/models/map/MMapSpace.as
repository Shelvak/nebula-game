package models.map
{
   import flash.errors.IllegalOperationError;
   
   import models.IStaticSpaceSectorObject;
   import models.StaticSpaceObjectsAggregator;
   import models.location.LocationMinimal;
   import models.map.events.MMapSpaceEvent;
   import models.map.events.MMapSpaceEventKind;
   
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Dispatched when <code>StaticSpaceObjectsAggregator</code> has been added.
    *  
    * @eventType models.map.events.MMapSpaceEvent.STATIC_OBJECTS_ADD
    */
   [Event(name="staticObjectsAdd", type="models.map.events.MMapSpaceEvent")]
   
   
   /**
    * Dispatched when <code>StaticSpaceObjectsAggregator</code> has been removed.
    *  
    * @eventType models.map.events.MMapSpaceEvent.STATIC_OBJECTS_REMOVE
    */
   [Event(name="staticObjectsRemove", type="models.map.events.MMapSpaceEvent")]
   
   
   /**
    * Dispatched when <code>IStaticSpaceSectorObject</code> has been added to or removed from a
    * <code>StaticSpaceObjectsAggregator</code> which has already been added to this map.
    * 
    * @eventType models.map.events.MMapSpaceEvent.STATIC_OBJECTS_CHANGE
    */
   [Event(name="staticObjectsChange", type="models.map.events.MMapSpaceEvent")]
   
   
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
            addAggregatorEventHandlers(aggregator);
            objects.addItem(aggregator);
            dispatchMMapSpaceEvent(MMapSpaceEvent.STATIC_OBJECTS_ADD, aggregator);
         }
         return object;
      }
      
      
      public function removeStaticObject(object:IStaticSpaceSectorObject) : *
      {
         var aggregator:StaticSpaceObjectsAggregator = findAggregatorIn(object.currentLocation);
         if (aggregator.length == 1)
         {
            objects.removeItemAt(objects.getItemIndex(aggregator));
            removeAggregatorEventHandlers(aggregator);
            dispatchMMapSpaceEvent(MMapSpaceEvent.STATIC_OBJECTS_REMOVE, aggregator);
         }
         aggregator.removeItemAt(aggregator.getItemIndex(object));
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
         addAggregatorEventHandlers(aggregator);
         dispatchMMapSpaceEvent(MMapSpaceEvent.STATIC_OBJECTS_ADD, aggregator);
         return aggregator;
      }
      
      
      public function removeStaticObjectsAggregator(aggregator:StaticSpaceObjectsAggregator) : StaticSpaceObjectsAggregator
      {
         objects.removeItemAt(objects.getItemIndex(aggregator));
         removeAggregatorEventHandlers(aggregator);
         dispatchMMapSpaceEvent(MMapSpaceEvent.STATIC_OBJECTS_REMOVE, aggregator);
         return aggregator;
      }
      
      
      /* ######################################### */
      /* ### OBJECTS AGGREGATOR EVENT HANDLERS ### */
      /* ######################################### */
      
      
      private function addAggregatorEventHandlers(aggregator:StaticSpaceObjectsAggregator) : void
      {
         aggregator.addEventListener(CollectionEvent.COLLECTION_CHANGE, aggregator_collectionChangeHandler);
      }
      
      
      private function removeAggregatorEventHandlers(aggregator:StaticSpaceObjectsAggregator) : void
      {
         aggregator.removeEventListener(CollectionEvent.COLLECTION_CHANGE, aggregator_collectionChangeHandler);
      }
      
      
      private function aggregator_collectionChangeHandler(event:CollectionEvent) : void
      {
         var aggregator:StaticSpaceObjectsAggregator = StaticSpaceObjectsAggregator(event.target);
         var object:IStaticSpaceSectorObject;
         switch (event.kind)
         {
            case CollectionEventKind.ADD:
               for each (object in event.items)
               {
                  dispatchMMapSpaceEvent(MMapSpaceEvent.STATIC_OBJECTS_CHANGE, aggregator, object,
                                         MMapSpaceEventKind.OBJECT_ADD);
               }
               break;
            case CollectionEventKind.REMOVE:
               for each (object in event.items)
               {
                  dispatchMMapSpaceEvent(MMapSpaceEvent.STATIC_OBJECTS_CHANGE, aggregator, object,
                                         MMapSpaceEventKind.OBJECT_REMOVE);
               }
               break;
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function dispatchMMapSpaceEvent(type:String,
                                              aggregator:StaticSpaceObjectsAggregator = null,
                                              object:IStaticSpaceSectorObject = null,
                                              kind:int = MMapSpaceEventKind.OBJECT_ADD) : void
      {
         if (hasEventListener(type))
         {
            var event:MMapSpaceEvent = new MMapSpaceEvent(type);
            event.kind = kind;
            event.object = object;
            event.objectsAggregator = aggregator;
            dispatchEvent(event);
         }
      }
      
      
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