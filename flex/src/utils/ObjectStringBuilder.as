package utils
{
   public class ObjectStringBuilder
   {
      private var _object: *;
      private const _values: Array = [];

      public function ObjectStringBuilder(object: *) {
         _object = object;
      }

      public function addProp(name: String): ObjectStringBuilder {
         Objects.paramNotEmpty("name", name);
         checkObject();
         _values.push(name + ": " + valueToString(_object[name]));
         return this;
      }
      
      public function addString(value: String): ObjectStringBuilder {
         Objects.paramNotEmpty("value", value);
         checkObject();
         _values.push(value);
         return this;
      }

      public function finish(includeClassName: Boolean = true): String {
         if (_object == null) {
            return valueToString(_object);
         }
         if (includeClassName) {
            _values.unshift("class: " + Objects.getClassName(_object));
         }
         return "[" + _values.join(", ") + "]"; 
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
      
      private function checkObject(): void {
         Objects.notNull(_object, "You can't invoke this method on null or undefined object");
      }
   }
}
