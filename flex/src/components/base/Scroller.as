package components.base
{
   import flash.events.MouseEvent;
   
   import mx.events.PropertyChangeEvent;
   
   import spark.components.Scroller;
   import spark.core.IViewport;
   
   
   /**
    * Modified version of <code>spark.components.Scroller</code> which has ability not to prevent default
    * behaviour of <code>MouseEvent.MOUSE_WHEEL</code> handlers if the scroller has not scrolled its content.
    * This version of a scroller also allows modifying scroll step.
    */
   public class Scroller extends spark.components.Scroller
   {
      private var _stepMultiplier:Number = 1;
      /**
       * Multiplier for <code>MOUSE_WHEEL</code> event <code>delta</code> property.
       * 
       * @default 1
       */
      public function set stepMultiplier(value:Number) : void
      {
         if (value < 0)
         {
            value = 0;
         }
         _stepMultiplier = value;
      }
      /**
       * @private
       */
      public function get stepMultiplier() : Number
      {
         return _stepMultiplier;
      }
      
      
      private var _preventIneffectiveEvents:Boolean = false;
      /**
       * If <code>false</code>, will allow propagation of ineffective mouse wheel events: events that did
       * not change scroll position in any way.
       */
      public function set preventIneffectiveEvents(value:Boolean) : void
      {
         _preventIneffectiveEvents = value;
      }
      /**
       * @private
       */
      public function get preventIneffectiveEvents() : Boolean
      {
         return _preventIneffectiveEvents;
      }
      
      
      protected override function attachSkin():void
      {
         super.attachSkin();
         skin.addEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler_capture, true);
         skin.addEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler_bubble);
      }
      
      
      protected override function detachSkin():void
      {
         skin.removeEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler_bubble);
         skin.removeEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler_capture, true);
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
      
      
      private function skin_mouseWheelHandler_capture(event:MouseEvent) : void
      {
         if (event.isDefaultPrevented() || !viewport || !viewport.visible)
         {
            return;
         }
         var sign:int = event.delta < 0 ? -1 : 1;
         event.delta *= _stepMultiplier;
         if (Math.abs(event.delta) < 1)
         {
            event.delta = sign;
         }
      }
      
      
      private var _oldVerticalScrollPosition:Number = NaN;
      private var _oldHorizontalScrollPosition:Number = NaN;
      
      
      private function skin_mouseWheelHandler_bubble(event:MouseEvent) : void
      {
         if (!event.isDefaultPrevented() || !viewport || !viewport.visible)
         {
            return;
         }
         
         if (!_preventIneffectiveEvents &&
             _oldVerticalScrollPosition == viewport.verticalScrollPosition &&
             _oldHorizontalScrollPosition == viewport.horizontalScrollPosition)
         {
            event.stopImmediatePropagation();
            dispatchMouseWheelEvent(event);
            return;
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