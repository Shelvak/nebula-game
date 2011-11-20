package utils
{
   import flash.utils.getQualifiedClassName;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;

   /**
    * Defines static methods for checking variable types. 
    */   
   public class TypeChecker
   {
      /**
       * Checks if a given object is a number: Number, int or uint.
       *
       * @param obj An object to be examined.
       *
       * @return true if the given object is a number, false - otherwise.
       */
      public static function isNumber(obj: *): Boolean {
         return obj is Number || obj is int || obj is uint;
      }

      /**
       * Checks if a given variable is of a primitive type. Here is the list of
       * AS3 data types that i consider to be primitive:
       * <ul>
       *    <li>null</li>
       *    <li>Boolean</li>
       *    <li>int</li>
       *    <li>uint</li>
       *    <li>Number</li>
       *    <li>String</li>
       * </ul>
       *
       * @param obj Variable of any type of which type primitiveness needs to be
       * determined.
       *
       * @return True, if a given object is of primitive type, false -
       * otherwise.
       */
      public static function isOfPrimitiveType(obj: * = null): Boolean {
         if (obj == null ||
                obj is Boolean ||
                obj is int ||
                obj is uint ||
                obj is Number ||
                obj is String) {
            return true;
         }
         else {
            return false;
         }
      }

      private static const PRIMITIVE_TYPES: ArrayCollection =
                              new ArrayCollection(["Number",
                                                   "int",
                                                   "uint",
                                                   "Boolean",
                                                   "String"]);

      public static function isPrimitiveType(type: String): Boolean {
         return PRIMITIVE_TYPES.contains(type);
      }


      private static const PRIMITIVE_CLASSES: ArrayCollection =
                              new ArrayCollection([Number,
                                                   int,
                                                   uint,
                                                   Boolean,
                                                   String]);

      public static function isPrimitiveClass(type: Class): Boolean {
         return PRIMITIVE_CLASSES.contains(type);
      }

      /**
       * Checks if two given objects are of the same data type.
       *
       * @param obj1 First object which type should be compared with other
       * object's type.
       * @param obj2 Second object which type should be comapred with the
       * type of the first object.
       *
       * @return true if both given objects are of the same data type, false -
       * otherwise.
       */
      public static function isOfSameType(obj1: *, obj2: *): Boolean {
         // Both parameters are null or the same object
         // Or they are numbers
         if (obj1 == obj2 ||
                isNumber(obj1) && isNumber(obj2)) {
            return true;
         }

         // Checking actual types
         return getQualifiedClassName(obj1) == getQualifiedClassName(obj2);
      }

      /**
       * Returns <code>true</code> if the given instance is of a <code>Vector</code> type
       * containing objects of any other type.
       */
      public static function isVector(instance: *): Boolean {
         if (instance == null) {
            return false;
         }
         return getQualifiedClassName(instance).indexOf("<") >= 0;
      }
      
      /**
       * Checks if a given instance is a collection (<code>Array</code>, <code>Vector</code> or
       * <code>IList</code>).
       */
      public static function isCollection(instance:*) : Boolean {
         return instance is Array || instance is IList || isVector(instance);
      }
   }
}