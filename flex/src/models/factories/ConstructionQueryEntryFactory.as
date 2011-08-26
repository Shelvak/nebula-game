package models.factories
{
   import models.constructionqueueentry.ConstructionQueueEntry;
   
   import utils.Objects;
   
   public class ConstructionQueryEntryFactory
   {
      /**
       * Creates a ConstructionQueryEntry form a given simple object.
       *  
       * @param data An object representing a ConstructionQueryEntry.
       * 
       * @return instance of <code>ConstructionQueryEntry</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data:Object) : ConstructionQueueEntry {
         return Objects.create(ConstructionQueueEntry, data);
      }
   }
}