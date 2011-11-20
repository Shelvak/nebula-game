package models.factories
{
   import models.technology.Technology;
   
   import utils.Objects;
   
   
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
      public static function fromObject(data:Object) : Technology {
         return Objects.create(Technology, data);
      }
      
   }
}