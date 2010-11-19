package models.unit
{
   import flash.errors.IllegalOperationError;
   
   import models.ModelsCollection;
   
   import utils.random.Rndm;
   
   
   public class UnitsList extends ModelsCollection
   {
      public function UnitsList(source:Array=null)
      {
         super(source);
      }
      
      
      /**
       * Removes units with given ids from the collection.
       * 
       * @return collection of units removed
       */
      public function removeWithIDs(ids:Array, silent:Boolean = false) : ModelsCollection
      {
         var removedUnits:ModelsCollection = new ModelsCollection();
         for each (var id:int in ids)
         {
            removedUnits.addItem(remove(id, silent));
         }
         return removedUnits;
      }
      
      
      public override function shuffle(random:Rndm=null):void
      {
         throw new IllegalOperationError("Method is not supported");
      }
   }
}