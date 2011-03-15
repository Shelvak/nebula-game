package utils.datastructures.editors
{
   public class ArrayEditor extends BaseEditor
   {
      private var _array:Array;
      
      
      /**
       * @param array an array to edit
       */
      public function ArrayEditor(array:Array)
      {
         super(array);
         _array = array;
      }
      
      
      public override function addItem(item:*) : *
      {
         _array.push(item);
         return item;
      }
      
      
      public override function removeAll() : void
      {
         _array.splice(0, length);
      }
      
      
      public override function get length() : int
      {
         return _array.length;
      }
   }
}