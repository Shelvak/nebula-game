package components.base.viewport.events
{
   import components.base.viewport.Viewport;
   
   import flash.events.Event;
   import flash.geom.Point;
   
   import spark.components.Group;
   
   public class ViewportEvent extends Event
   {
      public static const CLICK_EMPTY_SPACE:String = "clickEmptySpace";
      public static const CONTENT_RESIZE:String = "contentResize";
      public static const CONTENT_CHANGE:String = "contentChange";
      public static const CONTENT_MOVE:String = "contentMove";
      
      
      public function ViewportEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type, bubbles, cancelable);
      }
      
      
      /**
       * Used only for <code>CONTENT_MOVE</code>.
       */
      public var contentPosition:Point;
      
      
      /**
       * Used only for <code>CONTENT_CHANGE</code>.
       */
      public var contentOld:Group;
      
      
      /**
       * Used only for <code>CONTENT_CHANGE</code>.
       */
      public var contentNew:Group;
      
      
      /**
       * Typed alias for <code>target</code> property.
       */
      public function get viewport() : Viewport
      {
         return Viewport(target);
      }
   }
}