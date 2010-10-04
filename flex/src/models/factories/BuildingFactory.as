package models.factories
{
   import config.Config;
   
   import flash.utils.getDefinitionByName;
   
   import models.BaseModel;
   import models.building.Building;

   
   /**
    * Lets easily create instaces of buildings. 
    */
   public class BuildingFactory
   {
      /**
       * Creates a building form a given simple object.
       *  
       * @param data An object representing a building.
       * 
       * @return instance of <code>Building</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data:Object) : Building
      {
         if (!data)
         {
            return null;
         }
         try
         {
            return BaseModel.createModel(getDefinitionByName("models.building." + data.type) as Class, data);
         }
         catch (e:ReferenceError)
         {
            return BaseModel.createModel(Building, data);
         }
         return null;
      }
      
      
      /**
       * Creates building instance of a given type with <code>x, y, xEnd, yEnd</code>
       * properties set to these values are:
       * <ul>
       *    <li><code>x, y</code> - <code>0</code></li>
       *    <li><code>xEnd</code> - <code>Config.getBuildingWidth(type) - 1</code></li>
       *    <li><code>yEnd</code> - <code>Config.getBuildingHeight(type) - 1</code></li>
       * </ul>
       *  
       * @param type Type of a building. Use constants form
       * <code>BuildingType</code> class.
       * 
       * @return Instance of <code>Building</code>.
       */      
      public static function createDefault(type:String) : Building
      {
         var b:Building;
         try
         {
            b = new (getDefinitionByName("models.building." + type) as Class) ();
         }
         catch (e:ReferenceError)
         {
            b = new Building();
         }
         b.type = type;
         b.xEnd = Config.getBuildingWidth(type) - 1;
         b.yEnd = Config.getBuildingHeight(type) - 1;
         return b;
      }
   }
}