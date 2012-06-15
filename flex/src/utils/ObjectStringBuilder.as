package utils
{
   public class ObjectStringBuilder
   {
      private var _object: *;
      private var _props: Array;

      public function ObjectStringBuilder(object: *) {
         _object = object;
         _props = [];
      }

      public function addProp(name: String): ObjectStringBuilder {
         Objects.paramNotEmpty("name", name);
         Objects.notNull(_object, "You can't invoke this method on null or undefined object");
         _props.push(name + ": " + valueToString(_object[name]));
         return this;
      }

      public function finish(includeClassName: Boolean = true): String {
         if (_object == null) {
            return valueToString(_object);
         }
         return "[" + (includeClassName ? "class: " + Objects.getClassName(_object) + ", " : "")
            + _props.join(", ") + "]";
      }

      private function valueToString(value: *): String {
         if (value === undefined) {
            return "undefined";
         }
         if (value === null) {
            return "null";
         }
         if (value is String) {
            return '"' + value + '"';
         }
         return value.toString();
      }
   }
}
