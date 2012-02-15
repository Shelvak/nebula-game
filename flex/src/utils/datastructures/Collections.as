package utils.datastructures
{
   import interfaces.ICleanable;
   import interfaces.IEqualsComparable;
   
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.logging.ILogger;
   import mx.logging.Log;

   import utils.Objects;


   public class Collections
   {
      private static function get logger(): ILogger {
         return Log.getLogger("utils.datastructures.Collections");
      }

      /**
       * Special method for removing all elements from <code>IList</code>,
       * <code>Array</code> or <code>Vector</code> and calling
       * <code>cleanup()</code> on each <code>ICleanable</code> in the given
       * list.
       */
      public static function cleanListOfICleanables(items: *): void {
         var array: Array;
         if (items is IList) {
            const list: IList = IList(items);
            var index: int = 0;
            array = list.toArray();
            while (list.length > 0) {
               try {
                  list.removeItemAt(0);
               }
               catch (err:RangeError) {
                  logger.error(
                     "@cleanListOfICleanables: Error while trying to remove "
                        + "item at {0}: {1}", index, err.message
                  );
               }
               index++;
            }
            list.removeAll();
         }
         else if (items is Array) {
            array = items as Array;
         }
         else {
            return;
         }
         for each (var item: Object in array) {
            if (item is ICleanable) {
               ICleanable(item).cleanup();
            }
         }
         array.splice(0, array.length);
      }
      
      /**
       * Filters items in the given list.
       * 
       * @param list | <b>not null</b>
       * @param filterFunction | <b>not null</b>
       * 
       * @return collection view which is bound to the given <code>list</code>
       * and has given filter function in effect. This will be a new instance of
       * <code>ListCollectionView</code>. Once you don't need it, setting its
       * <code>list</code> property to <code>null</code> is recommended but
       * optional.
       * 
       * @see mx.collections.ICollectionView
       */
      public static function filter(list:IList,
                                    filterFunction: Function): ListCollectionView {
         Objects.paramNotNull("list", list);
         Objects.paramNotNull("filterFunction", filterFunction);
         return applyFilter(new ListCollectionView(list), filterFunction);
      }
      
      /**
       * Same as the following code snippet:
       * <pre>
       *    collection.filterFunction = filterFunction;
       *    collection.refresh();
       * </pre>
       *
       * @param collection | <b>not null</b>
       * @param filterFunction | <b>not null</b>
       * 
       * @return <code>collection</code>
       */
      public static function applyFilter(collection: ICollectionView,
                                         filterFunction: Function): * {
         Objects.paramNotNull("collection", collection);
         Objects.paramNotNull("filterFunction", filterFunction);
         collection.filterFunction = filterFunction;
         collection.refresh();
         return collection;
      }
      
      /**
       * Looks for the first item in the given list for which test function
       * returns <code>true</code> and returns its index. If no such item
       * exists, returns <code>-1</code>.
       *
       * @param list | <b>not null</b>
       * @param testFunction | <b>not null</b>
       */
      public static function findFirstIndex(list: IList,
                                            testFunction: Function): int {
         Objects.paramNotNull("list", list);
         Objects.paramNotNull("testFunction", testFunction);
         for (var idx: int = 0; idx < list.length; idx++) {
            if (testFunction(list.getItemAt(idx))) {
               return idx;
            }
         }
         return -1;
      }
      
      /**
       * Looks for the first item in the given list for which test function returns
       * <code>true</code> and returns it. If no such item exists, returns <code>null</code>.
       *
       * @param list | <b>not null</b>
       * @param testFunction | <b>not null</b>
       */
      public static function findFirst(list: IList, testFunction: Function): * {
         Objects.paramNotNull("list", list);
         Objects.paramNotNull("testFunction", testFunction);
         var idx: int = findFirstIndex(list, testFunction);
         return idx >= 0 ? list.getItemAt(idx) : null;
      }
      
      /**
       * Looks for the first item in the given list for which
       * <code>example.equals(item)</code> returns <code>true</code> and returns
       * its index. If no such item exists, returns <code>-1</code>.
       *
       * @param list | <b>not null</b>
       * @param example | <b>not null</b>
       */
      public static function findFirstIndexEqualTo(list: IList,
                                                   example: IEqualsComparable): int {
         Objects.paramNotNull("list", list);
         Objects.paramNotNull("example", example);
         return findFirstIndex(
            list,
            function(item: Object): Boolean {
               return example.equals(item);
            }
         );
      }
      
      /**
       * Looks for the first item in the given list which has <code>id</code> property equal to given
       * id and returns its index. If no such item exists, returns <code>-1</code>.
       *
       * @param list | <b>not null</b>
       * @param id | <b>&gt;= 0</b>
       */
      public static function findFirstIndexWithId(list: IList, id: int): int {
         Objects.paramNotNull("list", list);
         Objects.paramPositiveNumber("id", id, true);
         if (id == 0) {
            return -1;
         }
         return findFirstIndex(
            list,
            function(item: Object): Boolean {
               return item["id"] == id;
            }
         );
      }
      
      /**
       * Looks for the first item in the given list for which <code>example.equals(item)</code> returns
       * <code>true</code> and returns it. If no such item exists, returns <code>null</code>.
       *
       * @param list | <b>not null</b>
       * @param example | <b>not null</b>
       */
      public static function findFirstEqualTo(list:IList,
                                              example:IEqualsComparable): * {
         Objects.paramNotNull("list", list);
         Objects.paramNotNull("example", example);
         var idx:int = findFirstIndexEqualTo(list, example);
         return idx >= 0 ? list.getItemAt(idx) : null;
      }
      
      /**
       * Looks for the first item in the given list which has <code>id</code> property equal to given
       * id and returns it. If no such item exists, returns <code>null</code>.
       *
       * @param list | <b>not null</b>
       * @param id | <b>&gt;= 0</b>
       */
      public static function findFirstWithId(list: IList, id: int): * {
         Objects.paramNotNull("list", list);
         Objects.paramPositiveNumber("id", id, true);
         var idx: int = findFirstIndexWithId(list, id);
         return idx >= 0 ? list.getItemAt(idx) : null;
      }
      
      /**
       * Looks for the first item in the given list for which test function
       * returns <code>true</code> and returns it. If no such item exists,
       * returns <code>null</code>.
       *
       * @param list | <b>not null</b>
       * @param testFunction | <b>not null</b>
       * @param silent if <code>false</code>, will throw error if item to
       * remove can't be found; if <code>true</code>, does not throw any error
       * in such case and returns <code>null</code>
       */
      public static function removeFirst(list: IList,
                                         testFunction: Function,
                                         silent: Boolean = false): * {
         Objects.paramNotNull("list", list);
         Objects.paramNotNull("testFunction", testFunction);
         try {
            return list.removeItemAt(findFirstIndex(list, testFunction));
         }
         catch (error: RangeError) {
            if (!silent) {
               throw new Error(
                  "Could not find an item to remove (using testFunction)"
               );
            }
         }
         return null;
      }
      
      /**
       * Looks for the first item in the given list for which
       * <code>example.equals(item)</code> returns <code>true</code>, removes it
       * from the <code>list</code> and returns it.
       *
       * @param list | <b>not null</b>
       * @param example | <b>not null</b>
       * @param silent if <code>false</code>, will throw error if item to remove
       * can't be found; if <code>true</code>, does not throw this error and
       * returns <code>null</code>
       */
      public static function removeFirstEqualTo(list: IList,
                                                example: IEqualsComparable,
                                                silent: Boolean = false): * {
         Objects.paramNotNull("list", list);
         Objects.paramNotNull("example", example);
         try {
            return list.removeItemAt(findFirstIndexEqualTo(list, example));
         }
         catch (error: RangeError) {
            if (!silent) {
               throw new Error("Could not find an item equal to " + example);
            }
         }
         return null;
      }
   }
}