package models.factories
{
   import flash.utils.getDefinitionByName;
   
   import models.BaseModel;
   import models.location.Location;

   public class LocationFactory
   {
      /**
       * Creates a location form a given simple object.
       *  
       * @param data An object representing a location.
       * 
       * @return instance of <code>Location</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data:Object) : Location
      {
         if (!data)
         {
            return null;
         }
         try
         {
            return BaseModel.createModel(getDefinitionByName("models.battle." + data.type) as Class, data);
         }
         catch (e:ReferenceError)
         {
            return BaseModel.createModel(Location, data);
         }
         return null;
      }
   }
}