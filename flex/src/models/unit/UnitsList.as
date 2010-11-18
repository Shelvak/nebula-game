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
      
      
      public override function shuffle(random:Rndm=null):void
      {
         throw new IllegalOperationError("Method is not supported");
      }
   }
}