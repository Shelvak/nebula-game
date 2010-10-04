package models.factories
{

   import config.Config;
   
   import flash.utils.getDefinitionByName;
   
   import models.BaseModel;
   import models.technology.Technology;
   
   
   /**
    * Lets easily create instaces of technologies. 
    */
   public class TechnologyFactory
   {
      /**
       * Creates a technology form a given simple object.
       *  
       * @param data An object representing a technology.
       * 
       * @return instance of <code>Technology</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data:Object) : Technology
      {
         if (!data)
         {
            return null;
         }
         try
         {
            return BaseModel.createModel(getDefinitionByName("models.technology." + data.type) as Class, data);
         }
         catch (e:ReferenceError)
         {
            return BaseModel.createModel(Technology, data);
         }
         return null;
      }
      
   }
}