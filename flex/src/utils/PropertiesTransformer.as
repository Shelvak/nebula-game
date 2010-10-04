package utils
{
   import mx.collections.ArrayCollection;
   
   
   /**
    * Contains static methods for transforming objects with one type of
    * properties notation to another objects with different type of notation.
    * <b>Works only with dynamicaly added properties of objects.</b>
    * 
    * <p><i>Note: Objects that are made of other objects that have properties
    * pointing to each other or root object won't be reproduced completely:
    * those bidirectional pointers will not exist.</i></p>
    */
   public class PropertiesTransformer
   {
      // These to defines constants for property notation types that are
      // used in this class.
      private static const CAMEL_CASE: int = 0;
      private static const UNDER_SCORE: int = 1;
      
      
      /**
       * Transforms a given property form under_score to CamelCase notation. First letter
       * of resulting string will be a lower-case letter.
       *  
       * @param prop A property that needs to be transformed.
       *  
       * @return Transformed property.
       */
      public static function propToCamelCase (prop: String) :String
      {
         return StringUtil.underscoreToCamelCaseFirstLower(prop);
      }
      
      
      /**
       * Transforms a given property form CamelCase to under_score notation.
       *  
       * @param prop A property that needs to be transformed.
       * 
       * @return Transformed property.
       */	    
      public static function propToUnderscore (prop: String) :String
      {
         return StringUtil.camelCaseToUnderscore(prop);
      }
         
         
      /**
       * Creates identical object for a given one with all properties
       * transformed <b>recursively</b> form under_score notation to CamelCase
       * notation. <b>Works only with dynamicaly added properties of
       * objects.</b>
       * 
       * <p><i>Note: Does not work with objects that are made of other objects
       * that have properties pointing to each other or root object although
       * it will not enter infinite loop.</i></p>
       * 
       * @param obj Object that has to be be transformed.
       * 
       * @return Indentical object to a given one, however its properties
       * are of CamelCase notation instead of under_score.
       */
      public static function objectToCamelCase (obj: Object) :Object
      {
         return (transformObject (obj, CAMEL_CASE, new ArrayCollection ()));
      }
      
      
      /**
       * Creates identical object for a given one with all properties
       * transformed <b>recursively</b> form CamelCase notation to under_score
       * notation. <b>Works only with dynamicaly added properties of
       * objects.</b>
       * 
       * <p><i>Note: Does not work with objects that are made of other objects
       * that have properties pointing to each other or root object although
       * it will not enter infinite loop.</i></p>
       * 
       * @param obj Object that has to be be transformed.
       * 
       * @return Indentical object to a given one, however its properties
       * are of under_score notation instead of CamelCase.
       */
      public static function objectToUnderscore (obj: Object) :Object
      {
         return (transformObject (obj, UNDER_SCORE, new ArrayCollection ()));
      }
      
      
      // Recursively creates new object with a given properties notation form a
      // given object. Here a recursive call to the same method is performed for
      // any peroperty that holds a non-primitive type.
      private static function transformObject
            (obj: Object,
             notation: int,
             visitedObjs: ArrayCollection) :Object
      {
         visitedObjs.addItem (obj);
         var result:* = undefined;
         
         if (obj is Array)
         {
            result = [];
            for each (var item:Object in obj)
            {
               if (TypeChecker.isOfPrimitiveType(item))
               {
                  result.push(item);
               }
               else
               {
                  if (!visitedObjs.contains(item))
                  {
                     result.push(transformObject (item, notation, visitedObjs));
                  }
               }
            }
         }
         else
         {
            result = new Object();
            var transfProp:String;
            
            for (var prop:String in obj)
            {
               switch (notation)
               {
                  case CAMEL_CASE:
                     transfProp = propToCamelCase(prop)
                     break;
                  
                  case UNDER_SCORE:
                     transfProp = propToUnderscore(prop)
                     break;
               }
               
               if (TypeChecker.isOfPrimitiveType(obj[prop]))
               {
                  result[transfProp] = obj[prop];
               }
               else
               {
                  if (!visitedObjs.contains(obj[prop]))
                  {
                     result[transfProp] = transformObject(obj[prop], notation, visitedObjs);
                  }
               }
            }
         }
         
         return result;
      }
   }
}