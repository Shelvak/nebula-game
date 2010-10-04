package utils.datastructures
{
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   public class Set extends Proxy
   {
      private var values: ArrayCollection;
      private var hashKeys: Object = new Object();
      private var hash: Function;
      public var sorted: Boolean = false;
      
      public function Set(hashFunction: Function)
      {
         values = new ArrayCollection();
         super();
         hash = hashFunction;  
      }
      
      private var _sortField: SortField = new SortField();
      
      public function sort(sortField: SortField): void
      {
         if (!sorted || sortField != _sortField)
         {
            _sortField = sortField;
            values.sort = new Sort();
            values.sort.fields = [_sortField];
            values.refresh();
            sorted = true;
         }
      }
      
      override flash_proxy function nextNameIndex (index:int):int {
         if (!sorted)
            sort(_sortField);
         if (index < values.length) {
            return index + 1;
         }
         else {
            return 0;
         }
      }
      
      override flash_proxy function nextValue(index:int):* {
         if (!sorted)
            sort(_sortField);
         return values.getItemAt(index - 1);
      }
      
      public function addItem(item: *):Boolean
      {
         var key: String = hash(item);
         
         if (hashKeys[key] == null)
         {
            hashKeys[key] = item;
            values.addItem(item);
            sorted = false;
            return true;
         }
         return false;
      }
      
      public function removeItem(item: *): void
      {
         var key: String = hash(item);
         if (hashKeys[key] == null)
         {
            throw new Error('Item not found while removing: ' + item);
         }
         hashKeys[key] = null;
         values.removeItemAt(values.getItemIndex(item));
      }
      
      public function getElement(key: String): *
      {
         return hashKeys[key];
      }
      
      public function get count (): int
      {
         return values.length;
      }
   }
}