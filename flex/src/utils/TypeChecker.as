package utils
{
   import flash.utils.getQualifiedClassName;

   import mx.collections.IList;


   /**
    * Defines static methods for checking variable types. 
    */   
   public final class TypeChecker
   {
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
         return obj == null
                   || obj is Boolean
                   || obj is int
                   || obj is uint
                   || obj is Number
                   || obj is String;
      }

      public static function isPrimitiveClass(type: Class): Boolean {
         return type === Number
                   || type === int
                   || type === uint
                   || type === Boolean
                   || type === String;
      }

      public static function isGenericObject(obj: *): Boolean {
         return Objects.getClass(obj) === Object;
      }

      /**
       * Returns <code>true</code> if the given instance is of a <code>Vector</code> type
       * containing objects of any other type.
       */
      public static function isVector(instance: *): Boolean {
         if (instance == null) {
            return false;
         }
         return isVectorName(getQualifiedClassName(instance));
      }

      public static function isVectorName(className: String): Boolean {
         return className != null && className.indexOf(">") >= 0;
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