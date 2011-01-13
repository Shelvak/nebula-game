package utils.datastructures
{
   import interfaces.ICleanable;
   import interfaces.IEqualsComparable;
   
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;

   public class Collections
   {
      /**
       * Special method for removing all elements from <code>IList</code>, <code>Array</code> or
       * <code>Vector</code> and calling <code>cleanup()</code> on each <code>ICleanable</code> in the given
       * list.
       */
      public static function cleanListOfICleanables(items:*) : void
      {
         var length:int;
         if (items is IList)
         {
            var list:IList = IList(items);
            length = list.length;
            for (var i:int = 0; i < length; i++)
            {
               if (list.getItemAt(0) is ICleanable)
               {
                  ICleanable(list.getItemAt(0)).cleanup();
               }
            }
            list.removeAll();
         }
         else if (items is Array)
         {
            var array:Array = items as Array;
            for each (var item:Object in items)
            {
               if (item is ICleanable)
               {
                  ICleanable(item).cleanup();
               }
            }
            array.splice(0, array.length);
         }
      }
      
      
      /**
       * Filters items in the given list.
       * 
       * @param list instance of <code>mx.collection.IList</code> wich needs its items filtered 
       * @param filterFunction filter function as described by <code>ICollectionView.filterFunction</code>
       * 
       * @return collection view which is bound to the given <code>list</code> and has given filter
       * function in effect. This will be a new instance of <code>ListCollectionView</code>. Once you
       * don't need it, setting its <code>list</code> property to <code>null</code> is recommended
       * but optional
       * 
       * @see mx.collections.ICollectionView
       */
      public static function filter(list:IList, filterFunction:Function) : ListCollectionView
      {
         return applyFilter(new ListCollectionView(list), filterFunction);
      }
      
      
      /**
       * Same as the following code snippet:
       * <pre>
       *    collection.filterFunction = filterFunction;
       *    collection.refresh();
       * </pre>
       * 
       * @return <code>collection</code>
       */
      public static function applyFilter(collection:ICollectionView, filterFunction:Function) : *
      {
         collection.filterFunction = filterFunction;
         collection.refresh();
         return collection;
      }
      
      
      /**
       * Looks for the first item in the given list for which test function returns
       * <code>true</code> and returns its index. If no such item exists, returns <code>-1</code>.
       */
      public static function findFirstIndex(list:IList, testFunction:Function) : int
      {
         for (var idx:int = 0; idx < list.length; idx++)
         {
            if (testFunction(list.getItemAt(idx)))
            {
               return idx;
            }
         }
         return -1;
      }
      
      
      /**
       * Looks for the first item in the given list for which test function returns
       * <code>true</code> and returns it. If no such item exists, returns <code>null</code>.
       */
      public static function findFirst(list:IList, testFunction:Function) : *
      {
         var idx:int = findFirstIndex(list, testFunction);
         return idx >= 0 ? list.getItemAt(idx) : null;
      }
      
      
      /**
       * Looks for the first item in the given list for which <code>example.equals(item)</code> returns
       * <code>true</code> and returns its index. If no such item exists, returns <code>-1</code>.
       */
      public static function findFirstIndexEqualTo(list:IList, example:IEqualsComparable) : int
      {
         return findFirstIndex(list, function(item:Object) : Boolean { return example.equals(item) });
      }
      
      
      /**
       * Looks for the first item in the given list for which <code>example.equals(item)</code> returns
       * <code>true</code> and returns it. If no such item exists, returns <code>null</code>.
       */
      public static function findFirstEqualTo(list:IList, example:IEqualsComparable) : *
      {
         var idx:int = findFirstIndexEqualTo(list, example);
         return idx >= 0 ? list.getItemAt(idx) : null;
      }
      
      
      /**
       * Looks for the first item in the given list for which test function returns
       * <code>true</code> and returns it. If no such item exists, returns <code>null</code>.
       * 
       * @param silent if <code>false</code>, will throw error if item to remove can't be found;
       * if <code>true</code>, does not throw any errors and returns <code>null</code>
       */
      public static function removeFirst(list:IList, testFunction:Function, silent:Boolean = false) : *
      {
         try
         {
            list.removeItemAt(findFirstIndex(list, testFunction));
         }
         catch (error:RangeError)
         {
            if (!silent)
            {
               throw new Error("Could not find an item to remove (using testFunction)");
            }
         }
         return null;
      }
      
      
      /**
       * Looks for the first item in the given list for which <code>example.equals(item)</code> returns
       * <code>true</code>, removes it from the <code>list</code> and returns it.
       * 
       * @param silent if <code>false</code>, will throw error if item to remove can't be found;
       * if <code>true</code>, does not throw any errors and returns <code>null</code>
       */
      public static function removeFirstEqualTo(list:IList, example:IEqualsComparable, silent:Boolean = false) : *
      {
         try
         {
            list.removeItemAt(findFirstIndexEqualTo(list, example));
         }
         catch (error:RangeError)
         {
            if (!silent)
            {
               throw new Error("Could not find an item equal to " + example);
            }
         }
         return null;
      }
   }
}