package utils.datastructures
{
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;

   public class Collections
   {
      /**
       * Filters items in the given list.
       * 
       * @param list instance of <code>mx.collection.IList</code> wich needs its items filtered 
       * @param filterFunction filter function as described by <code>ICollectionView.filterFunction</code>
       * 
       * @return collection view which is bound to the given <code>list</code> and has given filter
       * function in effect. This will be a new instance of <code>ListCollectionView</code>
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
       * Adds all elements in the hash (values without keys) to the given collection.
       * 
       * @param hash source hash
       * @param collection <code>IList</code> or <code>ICollectionView</code> to add hash items to
       * 
       * @return <code>collection</code>
       */
      public static function hashToCollection(hash:Object, collection:*) : *
      {
         for each (var item:Object in hash)
         {
            collection.addItem(item);
         }
         return collection;
      }
   }
}