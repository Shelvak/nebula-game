package ext.hamcrest.collection 
{
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   
   import org.hamcrest.Matcher;
   import org.hamcrest.collection.array;
   
   
   /**
    * Works the same as <code>org.hamcrest.collection.array</code> but additionally accepts
    * <code>IList</code> as the collection of matchers (must be only one parameter passed).
    */   
   public function array(... rest) : Matcher
   {
      var matchers:Array = rest;
      var extractedMatchers:Array = [];
      if (matchers.length == 1 && (matchers[0] is IList || matchers[0] is ICollectionView))
      {
         for each (var matcher:Object in matchers[0])
         {
            extractedMatchers.push(matcher);
         }
         return org.hamcrest.collection.array(extractedMatchers);
      }
      return org.hamcrest.collection.array(rest);
   }
}