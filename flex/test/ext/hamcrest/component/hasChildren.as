package ext.hamcrest.component
{
   import org.hamcrest.Matcher;
   import org.hamcrest.core.allOf;

   /**
    * Asserts that <code>DisplayObjectContainer</code> has given children.
    */
   public function hasChildren(... rest) : Matcher
   {
      var matchers:Array = rest;
      
      if (matchers.length == 0 && matchers[0] is Array)
      {
         matchers = matchers[0];
      }
      
      return Function(allOf).apply(null, matchers.map(hasChildrenIterator));
   }
}


import ext.hamcrest.component.hasChild;
import org.hamcrest.Matcher;

internal function hasChildrenIterator(value:Object, i:int, a:Array) : Matcher
{
   return hasChild(value);
}