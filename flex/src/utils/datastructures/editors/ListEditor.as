package utils.datastructures.editors
{
   import mx.collections.IList;
   
   
   public class ListEditor extends BaseEditor
   {
      private var _list:IList;
      
      
      /**
       * @param list instance of a list to edit
       */
      public function ListEditor(list:IList)
      {
         super(list);
         _list = list;
      }
      
      
      public override function addItem(item:*) : *
      {
         _list.addItem(item);
         return item;
      }
      
      
      public override function removeAll() : void
      {
         _list.removeAll();
      }
      
      
      public override function get length() : int
      {
         return _list.length;
      }
   }
}