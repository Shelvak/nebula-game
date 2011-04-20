package ext.hamcrest.component
{
   import ext.hamcrest.object.equals;
   
   import flash.display.DisplayObjectContainer;
   
   import mx.collections.ArrayCollection;
   
   import org.hamcrest.BaseMatcher;
   import org.hamcrest.Description;
   import org.hamcrest.Matcher;
   
   import utils.components.DisplayListUtil;
   
   
   /**
    * Checks if <code>DisplayObjectContainer</code> has a given child.
    */
   public class HasChildMatcher extends BaseMatcher
   {
      private var _elementMatcher:Matcher;
      
      
      public function HasChildMatcher(value:Matcher)
      {
         super();
         _elementMatcher = value;
      }
      
      
      public override function matches(item:Object) : Boolean
      {
         var children:ArrayCollection = DisplayListUtil.getChildren(DisplayObjectContainer(item));
         for each (var child:Object in children)
         {
            if (_elementMatcher.matches(child))
            {
               return true;
            }
         }
         return false;
      }
      
      
      public override function describeMismatch(item:Object, mismatchDescription:Description) : void
      {
         mismatchDescription
            .appendValue(item)
            .appendText(" does not have child ")
            .appendDescriptionOf(_elementMatcher);
      }
      
      
      public override function describeTo(description:Description) : void
      {
         description.appendText("a container containing ").appendDescriptionOf(_elementMatcher);
      }
   }
}