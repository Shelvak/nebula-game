package models.factories
{
   import config.Config;
   
   import flash.utils.getDefinitionByName;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.unit.Unit;
   
   
   /**
    * Lets easily create instaces of units. 
    */
   public class UnitFactory
   {
      /**
       * Creates a unit form a given simple object.
       *  
       * @param data An object representing a unit.
       * 
       * @return instance of <code>Unit</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data:Object) : Unit
      {
         if (!data)
         {
            return null;
         }
         try
         {
            return BaseModel.createModel(getDefinitionByName("models.unit." + data.type) as Class, data);
         }
         catch (e:ReferenceError)
         {
            return BaseModel.createModel(Unit, data);
         }
         return null;
      }
      
      public static function fromObjects(units:Array) : Array
      {
         var unitModels: Array = [];
         for each (var unit: Object in units)
         {
            unitModels.push(fromObject(unit));
         }
         return unitModels;
      }
   }
}