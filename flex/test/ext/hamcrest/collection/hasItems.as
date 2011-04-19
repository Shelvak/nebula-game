package ext.hamcrest.collection
{
    import mx.collections.ICollectionView;
    import mx.collections.IList;
    
    import org.hamcrest.Matcher;
    import org.hamcrest.core.allOf;

    /**
     * Same as <code>org.hamcrest.collection.hasItems</code> except that it unpacks
     * <code>IList</code>, <code>ICollectionView</code> and <code>Array</code> as one-only argument. 
     */
    public function hasItems(... rest) : Matcher
    {
       var matchers:Array = rest;
       if (rest.length == 1 &&
           rest[0] is Array || rest[0] is IList || rest[0] is ICollectionView)
       {
          matchers = new Array();
          for each (var matcher:Object in rest[0])
          {
             matchers.push(matcher);
          }
       }
       return allOf.apply(null, matchers.map(hasItemsIterator));
    }
}

import org.hamcrest.Matcher;
import org.hamcrest.collection.hasItem;

internal function hasItemsIterator(value:Object, i:int, a:Array):Matcher
{
    return hasItem(value);
}
