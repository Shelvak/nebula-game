package models
{
   import ext.flex.mx.collections.ArrayCollectionSlave;
   
   import mx.collections.ArrayCollection;
   
   /**
    * @copy models.ModelsCollection
    */
   public class ModelsCollectionSlave extends ext.flex.mx.collections.ArrayCollectionSlave implements IModelsList
   {
      include "mixins/defaultIModelsListImpl.as";
      
      
      /**
       * @see mx.collections.ArrayCollection#ArrayCollection()
       */
      public function ModelsCollectionSlave(master:mx.collections.ArrayCollection, modifiable:Boolean = true)
      {
         super(master, modifiable);
      }
   }
}