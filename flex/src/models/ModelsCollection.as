package models
{
   import ext.flex.mx.collections.ArrayCollection;
   
   import mx.collections.IList;
   
   
   public class ModelsCollection extends ArrayCollection implements IModelsList
   {
      /**
       * Looks for and returns a <code>BaseModel</code> with a given id in a
       * given list.
       * 
       * @param list a list containing instances of <code>BaseModel</code>
       * @param id id of a model
       * 
       * @return <code>BaseModel</code> with a given id or <code>null</code>
       * if one could not be found. 
       */
      public static function findModel(list:IList, id:int) : *
      {
         for each (var item:BaseModel in list)
         {
            if (item != null && item.id == id)
            {
               return item;
            }
         }
         return null;
      }
      
      
      /**
       * Looks for and returns a <code>BaseModel</code> equal to the given model.
       * 
       * @param list a list containing instances of <code>BaseModel</code>
       * @param model model to look fore
       * 
       * @return <code>BaseModel</code> equal to <code>model</code> or <code>null</code> if one
       * can't be found.
       */
      public static function findExactModel(list:IList, model:BaseModel) : *
      {
         for each (var item:BaseModel in list)
         {
            if (item != null && item.equals(model))
            {
               return item;
            }
         }
         return null;
      }
      
      
      include "mixins/defaultIModelsListImpl.as";
      
      
      /**
       * @see mx.collections.ArrayCollection#ArrayCollection()
       */
      public function ModelsCollection(source:Array = null)
      {
         super(source);
      }
   }
}