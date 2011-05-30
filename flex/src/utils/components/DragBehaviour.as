package utils.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import interfaces.ICleanable;
   
   import utils.Objects;
   
   
   /**
    * Use this to attach drag behaviour to any display object. Here "drag behaviour" is:
    * <ol>
    *    <li>user presses a mouse botton while over the component</li>
    *    <li>while holding the mouse botton pressed user moves the mouse - the component follows it</li>
    *    <li>use releases the mouse button and the component remains in its current position</li>
    * </ol>
    * This will only work with components not contrained by Flex layout features (constraints, layouts).
    * 
    * <p>
    * You initialize this class by providing a display object (client) for the constructor. Then you
    * call configuration methods to customize the behaviour (see documentation of those methods for more
    * information). After you are finished you must call <code>setupComplete()</code> method. Further calls
    * to any of the methods mentioned above are not allowed and will cause <code>IllegalOperationError</code>
    * to be thrown. You have to explicitly keep a reference to each instance of <code>DragBehaviour</code> so
    * that it does not get collected by the GC.
    * </p>
    * 
    * <p><code>DragBehaviour</code> registers weak <code>MOUSE_DOWN</code> event listener on the client. The
    * behaviour is activated only if <code>MOUSE_DOWN</code> event's <code>target</code> property is the
    * <code>client</code> itself or <code>activator</code> (if one has been provided via
    * <code>activator()</code> setup method).</p>
    * 
    * <p><code>DragBehaviour</code> registers weak <code>MOUSE_UP</code> and <code>MOUSE_MOVE</code> event
    * listeners on the stage.</p>
    * 
    * <p>Although all listeners are weak it is recommended to call <code>cleanup()</code> method when
    * the instance is no longer needed.</p>
    */
   public class DragBehaviour implements ICleanable
   {
      private var _client:InteractiveObject;
      
      
      private function get clientIsContainer() : Boolean
      {
         return _client is DisplayObjectContainer;
      }
      
      
      private function get clientAsContainer() : DisplayObjectContainer
      {
         return DisplayObjectContainer(_client);
      }
      
      
      private function get stage() : Stage
      {
         return _client.stage;
      }
      
      
      /* ############# */
      /* ### SETUP ### */
      /* ############# */
      
      
      /**
       * Creates an instance of <code>DragBehaviour</code> that porvides drag behaviour for the given
       * display object.
       * 
       * @param client an instance of <code></code> <b>Not null.</b>
       */
      public function DragBehaviour(client:InteractiveObject)
      {
         _client = Objects.paramNotNull("client", client);;
      }
      
      
      private var _activator:InteractiveObject = null;
      /**
       * Use given interactive object as a drag activator instead of a <code>client</code> itself.
       * For this to work <code>client</code> must be an instance of <code>DisplayObjectContainer</code>
       * and <code>activator</code> should be direct or indirect child of <code>client</code>.
       * 
       * <p>If not specified defaults to <code>client</code>.</p>
       * 
       * @param activator <b>Not null. Direct or indirect child of <code>client</code>.</b>
       */
      public function activator(activator:InteractiveObject) : DragBehaviour
      {
         assertSetupNotComplete();
         _activator = Objects.paramNotNull("activator", activator);
         if (!clientIsContainer)
         {
            throw new IllegalOperationError(
               "Unable to configure activator: client must be DisplayObjectContainer."
            );
         }
         if (!clientAsContainer.contains(_activator))
         {
            throw new IllegalOperationError(
               "Unable to configure activator: " + _activator + " must be the child of client " + _client
            );
         }
         return this;
      }
      
      
      private var _boundsObject:DisplayObject = null;
      private function get useBoundsObject() : Boolean
      {
         return _boundsObject != null;
      }
      /**
       * A bounding object to be used. If specified, user won't be able to drag <code>client<code> out of
       * the stage area bounded by the given display object. For more information on this behaviour see
       * <code>boundsConstraints()</code> method documenation.
       * 
       * <p>By default <code>boundsObject</code> is not used.</p>
       * 
       * @param boundsObject <b>Not null.</b>
       * 
       * @see #boundsConstraints()
       * @see #fixOnBoundsObjectResize()
       */
      public function boundsObject(boundsObject:DisplayObject) : DragBehaviour
      {
         assertSetupNotComplete();
         _boundsObject = Objects.paramNotNull("boundsObject", boundsObject);
         return this;
      }
      
      
      private var _fixOnBoundsObjectRisize:Boolean = true;
      /**
       * Whether position of the <code>client</code> should be fixed when <code>boundsObject</code> (if used)
       * resizes: when this happens the <code>client</code> may end up in a position not allowed by
       * <code>boundsObject</code> and <code>boundsConstraints</code>.
       * 
       * <p>Defaults to <code>true</code> and has any effect if <code>boundsObject</code> is used.</p>
       * 
       * @see #boundsObject()
       * @see #boundsConstraints()
       */
      public function fixOnBoundsObjectResize(fixOnResize:Boolean) : DragBehaviour
      {
         assertSetupNotComplete();
         if (!useBoundsObject)
         {
            throw new IllegalOperationError("fixOnBoundsObjectRezize requires boundsObject to be specified");
         }
         _fixOnBoundsObjectRisize = fixOnResize;
         return this;
      }
      
      
      private var _innerEdgeAsDatum:Boolean = false;
      private var _left:Number = 0,
                  _right:Number = 0,
                  _top:Number = 0,
                  _bottom:Number = 0;
      /**
       * 
       * 
       * @param left
       * @param right
       * @param top
       * @param bottom
       * @param innerEdgeAsDatum
       * @return 
       * 
       */
      public function boundsConstraints(left:Number,
                                        right:Number,
                                        top:Number,
                                        bottom:Number,
                                        innerEdgeAsDatum:Boolean = false) : DragBehaviour
      {
         assertSetupNotComplete();
         _left = left;
         _right = right;
         _top = top;
         _bottom = bottom;
         _innerEdgeAsDatum = innerEdgeAsDatum
         return this;
      }
      
      
      private var _setupComplete:Boolean = false;
      /**
       * Call this when you are done customizing this instance and want your configuration to take an effect.
       * Once you call this you won't be able to call any of configaration methods.
       */
      public function setupComplete() : DragBehaviour
      {
         assertSetupNotComplete();
         _setupComplete = true;
         if (_activator == null)
         {
            _activator = _client;
         }
         _activator.addEventListener(MouseEvent.MOUSE_DOWN, activator_mouseDownHandler, false, 0, true);
         if (useBoundsObject && _fixOnBoundsObjectRisize)
         {
            // mx.events.ResizeEvent.RESIZE is the same as Event.RESIZE so no need for two different handlers
            _boundsObject.addEventListener(Event.RESIZE, boundsObject_resizeHandler, false, 0, true);
         }
         return this;
      }
      
      
      /**
       * Calling this method when isntance is no longer needed is optional but recommended.
       */
      public function cleanup() : void
      {
         if (_client != null)
         {
            _client = null;
         }
         if (_activator != null)
         {
            _activator.removeEventListener(MouseEvent.MOUSE_DOWN, activator_mouseDownHandler, false);
            _activator = null;
         }
         if (useBoundsObject && _fixOnBoundsObjectRisize)
         {
            _boundsObject.removeEventListener(Event.RESIZE, boundsObject_resizeHandler, false);
            _boundsObject = null;
         }
      }
      
      
      /* ############# */
      /* ### LOGIC ### */
      /* ############# */
      
      
      private function boundsObject_resizeHandler(event:Event) : void
      {
         fixClientPosition();
      }
      
      
      private var _capturedMouseX:Number = 0,
                  _capturedMouseY:Number = 0;
      private function captureMouseCoordinates() : void
      {
         _capturedMouseX = stage.mouseX;
         _capturedMouseY = stage.mouseY;
      }
      
      
      private var f_dragging:Boolean = false;
      
      
      private function activator_mouseDownHandler(event:MouseEvent) : void
      {
         if (f_dragging || event.target != _activator)
         {
            return;
         }
         captureMouseCoordinates();
         stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
         stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
         f_dragging = true;
      }
      
      
      private function stage_mouseMoveHandler(event:MouseEvent) : void
      {
         var oldMouseX:Number = _capturedMouseX,
             oldMouseY:Number = _capturedMouseY;
         captureMouseCoordinates();
         var dx:Number = _capturedMouseX - oldMouseX;
         var dy:Number = _capturedMouseY - oldMouseY;
         _client.x += dx;
         _client.y += dy;
         fixClientPosition();
         event.updateAfterEvent();
      }
      
      
      private static const POINT_0x0:Point = new Point(0, 0);
      
      
      private function fixClientPosition() : void
      {
         if (!useBoundsObject)
         {
            return;
         }
         var topLeftClient:Point = _client.localToGlobal(POINT_0x0);
         var bottomRightClient:Point = _client.localToGlobal(bottomRight(_client));
         if (_innerEdgeAsDatum)
         {
            var temp:Point = topLeftClient;
            topLeftClient = bottomRightClient;
            bottomRightClient = temp;
         }
         
         /**
          * top left
          */
         
         var topLeftBoundsObject:Point = _boundsObject.localToGlobal(POINT_0x0);
         
         var minX:Number = topLeftBoundsObject.x + _left,
             minY:Number = topLeftBoundsObject.y + _top;
         
         var alignedTop:Boolean = false,
             alignedLeft:Boolean = false;
         
         if (topLeftClient.y < minY)
         {
            _client.y += minY - topLeftClient.y;
         }
         if (topLeftClient.x < minX)
         {
            _client.x += minX - topLeftClient.x; 
         }
         
         /**
          * then bottom right
          */
         if (alignedTop && alignedLeft)
         {
            return;
         }
         
         var bottomRightBoundsObject:Point = _boundsObject.localToGlobal(bottomRight(_boundsObject));
         
         if (!alignedTop)
         {
            var maxY:Number = bottomRightBoundsObject.y - _bottom;
            if (bottomRightClient.y > maxY)
            {
               _client.y += maxY - bottomRightClient.y;
            }
         }
         if (!alignedLeft)
         {
            var maxX:Number = bottomRightBoundsObject.x - _right;
            if (bottomRightClient.x > maxX)
            {
               _client.x += maxX - bottomRightClient.x;
            }
         }
      }
      
      
      private function stage_mouseUpHandler(event:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false);
         f_dragging = false;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function bottomRight(object:DisplayObject) : Point
      {
         return new Point(object.width, object.height);
      }
      
      
      private function assertSetupNotComplete() : void
      {
         if (_setupComplete)
         {
            throw new IllegalOperationError(
               "This instance of DragBehaviour has already been customized. You can't call this method " +
               "if setupComplete() has already been called."
            );
         }
      }
   }
}