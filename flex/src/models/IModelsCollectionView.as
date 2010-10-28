package models
{
   import ext.flex.mx.collections.ICollectionView;
   
   public interface IModelsCollectionView extends ICollectionView
   {
      /**
       * Looks for and returns a model with a given id.
       *  
       * @param id id of a model
       * 
       * @return <code>BaseModel</code> with a given id or <code>null</code>
       * if one could not be found. 
       */
      function findModel(id:int) : *;
      
      
      /**
       * Looks for and returns a model equal to the given <code>model</code>.
       *  
       * @param model a model to compare instances in the collection against
       * 
       * @return <code>BaseModel</code> equal to <code>model</code> or <code>null</code>
       * if one can't be found.
       */
      function findExactModel(model:BaseModel) : *;
   }
}