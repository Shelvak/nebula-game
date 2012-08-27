package utils
{
   import flash.errors.IllegalOperationError;

   import interfaces.IEqualsComparable;


   public class Enum implements IEqualsComparable
   {
      public function Enum(name: String) {
         const CLASS: Class = Objects.getClass(this);
         if (CLASS === Enum) {
            throw new IllegalOperationError("This class is abstract");
         }
         else if (CLASS != null) {
            throw new IllegalOperationError(
               "Instantiation of enumeration class " + CLASS + " instances is not allowed");
         }
         _name = Objects.paramNotEmpty("name", name);
      }

      private var _name: String;
      public function get name(): String {
         return _name;
      }

      public function toString(): String {
         return "[Enum " + Objects.getClassName(this) + "." + name + "]";
      }

      public function equals(o: Object): Boolean {
         return this === o;
      }
   }
}
