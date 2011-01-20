package components.map.space
{
   import flash.events.MouseEvent;
   
   import spark.components.SkinnableContainer;
   
   
   public class CSpaceMapPopup extends SkinnableContainer
   {
      public function CSpaceMapPopup()
      {
         super();
         addSelfEventHandlers();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _transparentWhenNotUnderMouse:Boolean = true;
      /**
       * Should the popup become almost transparent when mouse pointer is not over it. Default is
       * <code>true</code>.
       */
      public function set transparentWhenNotUnderMouse(value:Boolean) : void
      {
         if (_transparentWhenNotUnderMouse != value)
         {
            _transparentWhenNotUnderMouse = value;
            f_transparentWhenUnderMouseChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get transparentWhenNotUnderMouse() : Boolean
      {
         return _transparentWhenNotUnderMouse;
      }
      
      
      private var _underMouse:Boolean = false;
      private function set underMouse(value:Boolean) : void
      {
         if (_underMouse != value)
         {
            _underMouse = value;
            f_underMouseChanged = true;
            invalidateProperties();
         }
      }
      
      
      private var f_underMouseChanged:Boolean = true,
                  f_transparentWhenUnderMouseChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_underMouseChanged || f_transparentWhenUnderMouseChanged)
         {
            alpha = _underMouse || !_transparentWhenNotUnderMouse ? 1 : 0.3;
         }
         f_underMouseChanged = f_transparentWhenUnderMouseChanged = false;
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.CLICK, this_mouseEventHandler);
         addEventListener(MouseEvent.MOUSE_MOVE, this_mouseEventHandler);
         addEventListener(MouseEvent.ROLL_OVER, this_rollOverEvent);
         addEventListener(MouseEvent.ROLL_OUT, this_rollOutEvent);
      }
      
      
      private function this_mouseEventHandler(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
      }
      
      
      private function this_rollOverEvent(event:MouseEvent) : void
      {
         underMouse = true;
      }
      
      
      private function this_rollOutEvent(event:MouseEvent) : void
      {
         if (event.target == this)
         {
            underMouse = false;
         }
      }
   }
}