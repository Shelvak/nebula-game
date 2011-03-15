package utils.datastructures.editors
{
   public class VectorEditor extends BaseEditor
   {
      private var _vector:Object;
      
      
      /**
       * @param vector a vector instance to edit
       */
      public function VectorEditor(vector:Object)
      {
         super(vector);
         _vector = vector;
      }
      
      
      public override function addItem(item:*) : *
      {
         _vector.push(item);
         return item;
      }
      
      
      public override function removeAll() : void
      {
         _vector.splice(0, length);
      }
      
      
      public override function get length() : int
      {
         return _vector.length;
      }
   }
}