package components.base
{
   import flash.events.MouseEvent;
   
   
   /**
    * Scroller which allows changing of scroll step size (scroll speed) on runtime.
    */
   public class ScrollerVariableScrollStep extends Scroller
   {
      private var _stepMultiplyer:Number = 1;
      /**
       * Multiplyer for <code>MOUSE_WHEEL</code> event <code>delta</code> property.
       * Values less than <code>1</code> will be ignored and <code>1</code> will be used instead.
       * 
       * @default 1
       */
      public function set stepMultiplyer(value:Number) : void
      {
         if (value < 1)
         {
            value = 1;
         }
         _stepMultiplyer = value;
      }
      /**
       * @private
       */
      public function get stepMultiplyer() : Number
      {
         return _stepMultiplyer;
      }
      
      
      protected override function attachSkin():void
      {
         super.attachSkin();
         skin.addEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler, true);
      }
      
      
      protected override function detachSkin():void
      {
         skin.removeEventListener(MouseEvent.MOUSE_WHEEL, skin_mouseWheelHandler);
         super.detachSkin();
      }
      
      
      private function skin_mouseWheelHandler(event:MouseEvent) : void
      {
         if (event.isDefaultPrevented() || !viewport || !viewport.visible)
         {
            return;
         }
         event.delta *= _stepMultiplyer;
      }
   }
}