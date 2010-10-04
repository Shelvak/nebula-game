package components.base
{
   import flash.events.MouseEvent;
   
   import mx.events.PropertyChangeEvent;
   
   import spark.components.Scroller;
   import spark.core.IViewport;
   
   
   /**
    * Modified version of <code>spark.components.Scroller</code> which
    * will not prevent default behaviour of <code>MouseEvent.MOUSE_WHEEL</code>
    * handlers if the scroller has not scrolled its content.
    */
   public class Scroller extends spark.components.Scroller
   {
      protected override function attachSkin():void
      {
         super.attachSkin();
         skin.addEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);
      }
      
      
      protected override function detachSkin():void
      {
         skin.removeEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);
         super.detachSkin();
      }
      
      
      public override function set viewport(value:IViewport):void
      {
         uninstallViewport(viewport);
         super.viewport = value;
         installViewport(viewport);
      }
      
      
      private function installViewport(viewport:IViewport):void
      {
         if (viewport)
         {
            _oldVerticalScrollPosition = viewport.verticalScrollPosition;
            _oldHorizontalScrollPosition = viewport.horizontalScrollPosition;
         }
      }
      
      
      private function uninstallViewport(viewport:IViewport):void
      {
         _oldHorizontalScrollPosition = NaN;
         _oldVerticalScrollPosition = NaN;
      }
      
      
      private var _oldVerticalScrollPosition:Number = NaN;
      private var _oldHorizontalScrollPosition:Number = NaN;
      
      
      private function skin_mouseWheelHandler(event:MouseEvent) : void
      {
         if (!event.isDefaultPrevented() || !viewport || !viewport.visible)
         {
            return;
         }
         
         if (_oldVerticalScrollPosition == viewport.verticalScrollPosition &&
             _oldHorizontalScrollPosition == viewport.horizontalScrollPosition)
         {
            event.stopImmediatePropagation();
            dispatchMouseWheelEvent(event);
         }
         _oldVerticalScrollPosition = viewport.verticalScrollPosition;
         _oldHorizontalScrollPosition = viewport.horizontalScrollPosition;
      }
      
      
      private function dispatchMouseWheelEvent(event:MouseEvent) : void
      {
         dispatchEvent(new MouseEvent(
            MouseEvent.MOUSE_WHEEL,
            event.bubbles,
            event.cancelable,
            event.localX,
            event.localY,
            event.relatedObject,
            event.ctrlKey,
            event.altKey,
            event.shiftKey,
            event.buttonDown,
            event.delta
         ));
      }
   }
}