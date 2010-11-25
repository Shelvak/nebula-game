package models.factories
{
   import flash.utils.getDefinitionByName;
   
   import models.BaseModel;
   import models.constructionqueueentry.ConstructionQueueEntry;
   
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
      public static function fromObject(data:Object) : ConstructionQueueEntry
      {
         if (!data)
         {
            return null;
         }
         return BaseModel.createModel(ConstructionQueueEntry, data);
      }
   }
}