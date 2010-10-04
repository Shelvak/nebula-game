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
         try
         {
            return BaseModel.createModel(getDefinitionByName("models.constructionqueryentry." + data.type) as Class, data);
         }
         catch (e:ReferenceError)
         {
            return BaseModel.createModel(ConstructionQueueEntry, data);
         }
         return null;
      }
   }
}