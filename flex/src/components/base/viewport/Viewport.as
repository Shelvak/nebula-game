package components.base.viewport
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.base.viewport.events.ViewportEvent;
   
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   
   import interfaces.ICleanable;
   
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.ResizeEvent;
   
   import spark.components.Group;
   import spark.components.HScrollBar;
   import spark.components.Scroller;
   import spark.components.SkinnableContainer;
   import spark.components.VScrollBar;
   import spark.core.SpriteVisualElement;
   import spark.effects.Animate;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   
   import utils.components.DisplayListUtil;
   
   
   /**
    * Dispatched when user clicks on an empty space of a viewport.
    * 
    * @eventType components.base.viewport.events.ViewportEvent.CLICK_EMPTY_SPACE
    */
   [Event(name="clickEmptySpace", type="components.base.viewport.events.ViewportEvent")]
   
   /**
    * Dispatched when zoom changes.
    * 
    * @eventType components.base.viewport.events.ViewportEvent.CONTENT_RESIZE 
    */
   [Event(name="contentResize", type="components.base.viewport.events.ViewportEvent")]
   
   /**
    * Dispatched when content is changed.
    * 
    * @eventType components.base.viewport.events.ViewportEvent.CONTENT_CHANGE
    */
   [Event(name="contentChange", type="components.base.viewport.events.ViewportEvent")]
   
   /**
    * Dispatched when content is moved.
    * 
    * @eventType components.base.viewport.events.ViewportEvent.CONTENT_MOVE
    */
   [Event(name="contentMove", type="components.base.viewport.events.ViewportEvent")]
   
   
   [DefaultProperty("content")]
   /**
    * Base class for a viewport. This implementation only allows dragging content with the mouse.
    */
   public class Viewport extends SkinnableContainer implements ICleanable
   {
      private static const MOVE_EFFECT_DURATION:Number = 500;
      private static const KEYBOARD_MOVE_DELTA:int = 50;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      private var _contentScrollAnimator:Animate;
      
      
      /**
       * @param visibleAreaTracker optional tracker that will be notified of viewport size,
       *                           content position and size changes so that visible area of
       *                           the content in this viewport could be tracked
       */
      public function Viewport(visibleAreaTracker:VisibleAreaTracker = null)
      {
         super();
         _visibleAreaTracker = visibleAreaTracker;
         _contentScrollAnimator = new Animate();
         _contentScrollAnimator.duration = MOVE_EFFECT_DURATION;
         addSelfEventHandlers();
         addGlobalEventHandlers();
      }
      
      private var f_cleanupCalled:Boolean = false;
      
      public function cleanup() : void
      {
         if (f_cleanupCalled)
            return;
         
         _visibleAreaTracker = null;
         removeSelfEventHandlers();
         removeGlobalEventHandlers();
         if (_contentScrollAnimator)
         {
            _contentScrollAnimator.stop();
            _contentScrollAnimator.target = null;
            _contentScrollAnimator = null;
         }
         if (_content && _contentContainer.contains(_content))
         {
            uninstallContent(_content);
            _content = null;
         }
         if (_contentOld && _contentContainer.contains(_contentOld))
         {
            uninstallContent(_contentOld);
            _contentOld = null
         }
         if (_scroller)
         {
            contentGroup.removeElement(_scroller);
            _scroller = null;
         }
         else if (_viewport)
         {
            contentGroup.removeElement(_viewport);
         }
         overlay = null;
         _underlayImage = null;
         _contentContainer = null;
         _viewport = null;
         
         f_cleanupCalled = true;
      }
      
      /* ############################ */
      /* ### VISIBLE AREA TRACKER ### */
      /* ############################ */
      
      private var f_initializeVisibleAreaTracker:Boolean = false;
      private var _visibleAreaTracker:VisibleAreaTracker;
      protected function get visibleAreaTracker() : VisibleAreaTracker {
         return _visibleAreaTracker;
      }
      
      private function callContentInitialized() : void {
         f_initializeVisibleAreaTracker = false;
         if (_visibleAreaTracker != null && _content != null) {
            var contentPosition:Point = contentPosition_VCS();
            _visibleAreaTracker.contentInitialized(
               getLayoutBoundsWidth(),
               getLayoutBoundsHeight(),
               contentPosition.x,
               contentPosition.y,
               _content.width,
               _content.height,
               _content.scaleX
            );
         }
      }
      
      private function callUpdateContentPosition() : void {
         if (_visibleAreaTracker != null && _content != null) {
            var contentPosition:Point = contentPosition_VCS();
            _visibleAreaTracker.updateContentPosition(
               contentPosition.x,
               contentPosition.y
            );
         }
      }
      
      private function callUpdateContentScale() : void {
         if (_visibleAreaTracker != null && _content != null) {
            _visibleAreaTracker.updateContentScale(_content.scaleX);
         }
      }
      
      private function callUpdateViewportSize() : void {
         if (_visibleAreaTracker != null && _content != null) {
            _visibleAreaTracker.updateViewportSize(
               getLayoutBoundsWidth(),
               getLayoutBoundsHeight()
            );
         }
      }
      
      private function callUpdateComplete() : void {
         if (_visibleAreaTracker != null && _content != null) {
            _visibleAreaTracker.updateComplete();
         }
      }
            
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _contentContainer:Group;
      private var _viewport:Group;
      private var _scroller:Scroller;
      private var _underlaySprite:SpriteVisualElement
      
      
      private var f_childrenCreated:Boolean = false;
      
      
      /**
       * Classes extending <code>Viewport</code> must override this and return <code>Scroller</code>
       * instance if it should be used or <code>null</code> otherwise.
       */
      protected function createScroller() : Scroller
      {
         throw new IllegalOperationError("This method is abstract!");
      }
      
      
      protected override function createChildren() : void
      {
         if (f_cleanupCalled) {
            super.createChildren();
            return;
         }
         
         _contentContainer = new Group();
         _contentContainer.mouseEnabled = false;
         _viewport = new Group();
         _viewport.addElement(_contentContainer);
         _viewport.clipAndEnableScrolling = true;
         _viewport.mouseEnabled = false;
         _contentScrollAnimator.target = _viewport;
         
         // scroller is optional
         _scroller = createScroller();
         if (_scroller)
         {
            _scroller.left =
            _scroller.right =
            _scroller.top =
            _scroller.bottom = 0;
            _scroller.viewport = _viewport;
            _scroller.setStyle("horizontalScrollPolicy", ScrollPolicy.AUTO);
            _scroller.setStyle("verticalScrollPolicy", ScrollPolicy.AUTO);
            _scroller.mouseEnabled = false;
         }
         
         _underlaySprite = new SpriteVisualElement();
         _underlaySprite.left =
         _underlaySprite.right =
         _underlaySprite.top =
         _underlaySprite.bottom = 0;
         _underlaySprite.mouseEnabled =
         _underlaySprite.mouseChildren = false;
         
         super.createChildren();
      }
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         
         if (f_cleanupCalled)
            return;
         
         if (instance == contentGroup)
         {
            contentGroup.mouseEnabled = false;
            contentGroup.addElement(_underlaySprite);
            if (_scroller)
            {
               contentGroup.addElement(_scroller);
            }
            else
            {
               _viewport.left =
               _viewport.right =
               _viewport.top =
               _viewport.bottom = 0;
               contentGroup.addElement(_viewport);
            }
         }
      }
      
      
      /* ############################################# */
      /* ### CONTENT PROPERTIES AND INITIALIZATION ### */
      /* ############################################# */
      
      
      private var _contentOld:Group;
      private var _content:Group;
      /**
       * Container which is used as content for the viewport. 
       */
      public function set content(value:Group) : void
      {
         if (_content != value)
         {
            if (_contentOld == null)
            {
               _contentOld = _content;
            }
            _content = value;
            f_contentChanged = true;
            f_contentSizeChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get content() : Group
      {
         return _content;
      }
      
      
      /**
       * Actual width (with respect to scaling) of <code>content</code>.
       */
      protected function get contentScaledWidth() : Number
      {
         return _content ? _content.width * _content.scaleX : 0;
      }
      
      
      /**
       * Actual height (with respect to scaling) of <code>content</code>.
       */
      protected function get contentScaledHeight() : Number
      {
         return _content ? _content.height * _content.scaleY : 0;
      }
      
      
      /**
       * Container that holds content and is actually moved around.
       */
      protected function get contentContainer() : Group
      {
         return _contentContainer;
      }
      
      
      /**
       * You should register any event listeners with <code>code</code> here and do other
       * modifications for the content before it is added to the display list. Calling
       * <code>super.installContent()</code> should be the last thing you do if you override this
       * method.
       */
      protected function installContent(content:Group) : void
      {
         addContentEventHandlers(content);
         content.verticalCenter = 0;
         content.horizontalCenter = 0;
         _contentContainer.addElement(content);
      }
      
      
      /**
       * Unregister any event listeners registerend with the content here and release other
       * resources related to content to make it available for garbage collection.
       */
      protected function uninstallContent(content:Group) : void
      {
         removeContentEventHandlers(content);
         _contentContainer.removeElement(content);
         if (content is ICleanable)
         {
            ICleanable(content).cleanup();
         }
      }
      
      
      /* ############### */
      /* ### OVERLAY ### */
      /* ############### */
      
      
      private var _overlayOld:UIComponent;
      private var _overlay:UIComponent;
      public function set overlay(value:UIComponent) : void
      {
         if (_overlay != value)
         {
            if (!_overlayOld)
            {
               _overlayOld = _overlay;
            }
            _overlay = value;
            if (_overlay)
            {
               _overlay.mouseEnabled = false;
            }
            f_overlayChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get overlay() : UIComponent
      {
         return _overlay;
      }
      
      
      private function installOverlay(overlay:UIComponent) : void
      {
         overlay.mouseEnabled = false;
         overlay.left =
         overlay.right =
         overlay.top =
         overlay.bottom = 0;
         contentGroup.addElement(overlay);
      }
      
      
      private function uninstallOverlay(overlay:UIComponent) : void
      {
         contentGroup.removeElement(overlay);
      }
      
      
      /* ################ */
      /* ### UNDERLAY ### */
      /* ################ */
      
      
      private function get haveUnderlay() : Boolean
      {
         return _underlayImage != null;
      }
      
      
      private var _underlayImage:BitmapData;
      public function set underlayImage(value:BitmapData) : void
      {
         if (_underlayImage != value)
         {
            _underlayImage = value;
            f_underlayNeedsRedraw = true;
            invalidateDisplayList();
         }
      }
      /**
       * @private
       */
      public function get underlayImage() : BitmapData
      {
         return _underlayImage;
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _underlayScrollSpeedRatio:Number = 1;
      public function set underlayScrollSpeedRatio(value:Number) : void
      {
         value = value < 0.1 ? 0.1 : value;
         value = value > 10  ? 10  : value;
         if (_underlayScrollSpeedRatio != value)
         {
            _underlayScrollSpeedRatio = value;
         }
      }
      /**
       * @private
       */
      public function get underlayScrollSpeedRatio() : Number
      {
         return _underlayScrollSpeedRatio;
      }
      
      
      private var _paddingHorizontal:uint = 0;
      /**
       * Horizontal padding (left and right) for content.
       * 
       * @default 0
       */
      public function set paddingHorizontal(value:uint) : void
      {
         if (_paddingHorizontal != value)
         {
            _paddingHorizontal = value;
            f_paddingChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private 
       */
      public function get paddingHorizontal() : uint
      {
         return _paddingHorizontal;
      }
      
      
      private var _paddingVertical:uint = 0;
      /**
       * Vertical padding (top and bottom) for content.
       * 
       * @default 0
       */
      public function set paddingVertical(value:uint) : void
      {
         if (_paddingVertical != value)
         {
            _paddingVertical = value;
            f_paddingChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private 
       */
      public function get paddingVertical() : uint
      {
         return _paddingVertical;
      }
      
      
      private var f_contentChanged:Boolean = true,
                  f_overlayChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_cleanupCalled)
            return;
         
         if (f_contentChanged)
         {
            var event:ViewportEvent = new ViewportEvent(ViewportEvent.CONTENT_CHANGE);
            event.contentOld = _contentOld;
            event.contentNew = _content;
            if (_contentOld)
            {
               uninstallContent(_contentOld);
               _contentOld = null;
            }
            if (_content)
            {
               f_initializeVisibleAreaTracker = true;
               installContent(_content);
            }
            dispatchEvent(event);
         }
         
         if (f_overlayChanged)
         {
            if (_overlayOld)
            {
               uninstallOverlay(_overlayOld);
               _overlayOld = null;
            }
            if (_overlay)
            {
               installOverlay(_overlay);
            }
         }
         
         f_contentChanged = f_overlayChanged = false;
      }
      
      
      private var f_paddingChanged:Boolean = true,
                  f_contentSizeChanged:Boolean = true,
                  f_sizeChanged:Boolean = true,
                  f_underlayNeedsRedraw:Boolean = true;
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         
         if (f_cleanupCalled)
            return;
         
         if ((f_paddingChanged || f_contentSizeChanged || f_sizeChanged) && _content)
         {
            _contentContainer.width = contentScaledWidth + paddingHorizontal * 2;
            _contentContainer.height = contentScaledHeight + paddingVertical * 2;
            if (_contentContainer.width < uw)
            {
               _contentContainer.width = uw;
            }
            if (_contentContainer.height < uh)
            {
               _contentContainer.height = uh;
            }
            dispatchEvent(new ViewportEvent(ViewportEvent.CONTENT_RESIZE));
         }
         
         if (f_sizeChanged || f_underlayNeedsRedraw)
         {
            var g:Graphics = _underlaySprite.graphics;
            g.clear();
            if (haveUnderlay)
            {
               g.beginBitmapFill(_underlayImage,
                                 new Matrix(1, 0, 0, 1,
                                            -_viewport.horizontalScrollPosition * _underlayScrollSpeedRatio,
                                            -_viewport.verticalScrollPosition * _underlayScrollSpeedRatio),
                                 true, true);
               g.drawRect(0, 0, uw, uh);
               g.endFill();
            }
         }
         
         f_sizeChanged = f_underlayNeedsRedraw = f_paddingChanged = f_contentSizeChanged = false;
      }
      
      
      /* ############################# */
      /* ### MOVING CONTENT AROUND ### */
      /* ############################# */
      
      
      /**
       * Centers content in the viewport. 
       */      
      public function centerContent() : void
      {
         if (f_cleanupCalled)
            return;
         
         if (_content)
         {
            updateScrollPosition(new Point(
               (_contentContainer.width - width) / 2,
               (_contentContainer.height - height) / 2
            ));
         }
      }
      
      
      /**
       * Moves the content by the given amount of pixels. 
       * 
       * @param delta deltas must be given in content's coordinate space
       * @param useAnimation indicates if content should be moved smoothly (<code>true</code>)
       * or instantly (<code>false</code>)
       */      
      public function moveContentBy(delta:Point, useAnimation:Boolean = false, animationCompleteHandler:Function = null) : void
      {
         if (f_cleanupCalled || !_content)
            return;
         
         var endPosition:Point = getBoundedScrollPosition(new Point(
            _viewport.horizontalScrollPosition - delta.x * content.scaleX,
            _viewport.verticalScrollPosition - delta.y * content.scaleY
         ));
         if (useAnimation)
         {
            _contentScrollAnimator.end();
            var paths:Vector.<MotionPath> = new Vector.<MotionPath>();
            var startKeyframeHSP:Keyframe = new Keyframe(0, _viewport.horizontalScrollPosition);
            var endKeyframeHSP:Keyframe = new Keyframe(_contentScrollAnimator.duration, endPosition.x);
            paths.push(new MotionPath("horizontalScrollPosition"));
            paths[0].keyframes = Vector.<Keyframe>([startKeyframeHSP, endKeyframeHSP]);
            var startKeyframeVSP:Keyframe = new Keyframe(0, _viewport.verticalScrollPosition);
            var endKeyframeVSP:Keyframe = new Keyframe(_contentScrollAnimator.duration, endPosition.y);
            paths.push(new MotionPath("verticalScrollPosition"));
            paths[1].keyframes = Vector.<Keyframe>([startKeyframeVSP, endKeyframeVSP]);
            _contentScrollAnimator.motionPaths = paths;
            function effectUpdateHandler(event:EffectEvent) : void
            {
               f_underlayNeedsRedraw = true;
               invalidateDisplayList();
            }
            function effectEndHandler(event:EffectEvent) : void
            {
               _contentScrollAnimator.removeEventListener(EffectEvent.EFFECT_END, effectEndHandler);
               _contentScrollAnimator.removeEventListener(EffectEvent.EFFECT_UPDATE, effectUpdateHandler);
               updateScrollPosition(new Point(
                  _viewport.horizontalScrollPosition,
                  _viewport.verticalScrollPosition
               ));
               if (animationCompleteHandler != null)
               {
                  animationCompleteHandler();
               }
            }
            _contentScrollAnimator.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            _contentScrollAnimator.addEventListener(EffectEvent.EFFECT_UPDATE, effectUpdateHandler);
            _contentScrollAnimator.play();
         }
         else
         {
            _contentScrollAnimator.end();
            updateScrollPosition(endPosition);
         }
      }
      
      
      /**
       * Moves the content to a given coordinates (ensures these coordinates appear
       * at the center of a viewport or at least are visible if bounds of the
       * content container are reached). Given coordinates must be in content's coordinate space.
       */      
      public function moveContentTo(point:Point, useAnimation:Boolean = false, animationCompleteHandler:Function = null) : void
      {
         if (f_cleanupCalled)
            return;
         
         if (_content)
         {
            moveContentBy(
               centerPointViewport_CCS().subtract(point),
               useAnimation, animationCompleteHandler
            );
         }
      }
      
      
      /**
       * Indicates if the content container is beeing dragged with a mouse. 
       */
      private var f_contentOnDrag:Boolean = false;
      /**
       * Indicates if the content container has been actully moved between <code>MOUSE_DOWN</code>
       * and <code>MOUSE_UP</code> events.
       */
      private var f_contentMoved:Boolean = false;
      
      
      /**
       * Old mouse coordinates (on stage) before the MOUSE_MOVE event.
       */
      private var _oldMouseX:Number = 0;
      private var _oldMouseY:Number = 0;
      
      
      private function startContentDrag(event:MouseEvent) : void
      {
         if (f_cleanupCalled ||
             !_content ||
             DisplayListUtil.isInsideType(event.target, VScrollBar) ||
             DisplayListUtil.isInsideType(event.target, HScrollBar) ||
             _overlay && DisplayListUtil.isInsideInstance(event.target, _overlay))
         {
            return;
         }
         if (event.buttonDown)
         {
            addEventListener(MouseEvent.MOUSE_MOVE, doContentDrag, true);
            _oldMouseX = stage.mouseX;
            _oldMouseY = stage.mouseY;
            f_contentOnDrag = true;
         }
      }
      
      
      private function doContentDrag(event:MouseEvent) : void
      {
         if (!f_cleanupCalled && _content && f_contentOnDrag && event.buttonDown)
         {
            var mouseX:Number = stage.mouseX;
            var mouseY:Number = stage.mouseY;
            moveContentBy(new Point(
               (mouseX - _oldMouseX) / content.scaleX,
               (mouseY - _oldMouseY) / content.scaleY
            ));
            _oldMouseX = mouseX;
            _oldMouseY = mouseY;
            f_contentMoved = true;
            event.stopImmediatePropagation();
         }
      }
      
      
      private function stopContentDrag() : void
      {
         if (f_cleanupCalled)
            return;
         
         f_contentOnDrag = false;
         removeEventListener(MouseEvent.MOUSE_MOVE, doContentDrag);
      }
      
      
      private function getBoundedScrollPosition(position:Point) : Point
      {
         var hsp:Number = position.x;
         var vsp:Number = position.y;
         var hspMax:Number = _viewport.contentWidth - _viewport.getLayoutBoundsWidth();
         var vspMax:Number = _viewport.contentHeight - _viewport.getLayoutBoundsHeight();
         hsp = hsp < 0 ? 0 : hsp > hspMax ? hspMax : hsp;
         vsp = vsp < 0 ? 0 : vsp > vspMax ? vspMax : vsp;
         return new Point(hsp, vsp);
      }
      
      
      private function updateScrollPosition(position:Point) : void
      {
         // check the bounds to avoid _scrollerViewport jumping a few times around before it settles
         position = getBoundedScrollPosition(position);
         
         _viewport.horizontalScrollPosition = position.x;
         _viewport.verticalScrollPosition = position.y;
         var contentMoveEvent:ViewportEvent = new ViewportEvent(ViewportEvent.CONTENT_MOVE);
         contentMoveEvent.contentPosition = new Point(paddingHorizontal - position.x, paddingVertical - position.y);
         dispatchEvent(contentMoveEvent);
         f_underlayNeedsRedraw = true;
         invalidateDisplayList();
      }
      
      
      /* ############################################################# */
      /* ### COORDINATES IN VIEWPORT AND CONTENT CORRDINATE SPACES ### */
      /* ############################################################# */
      
      
      protected function viewportToContent(pointVCS:Point) : Point
      {
         return new Point(
            (_viewport.horizontalScrollPosition - paddingHorizontal + pointVCS.x) / content.scaleX,
            (_viewport.verticalScrollPosition - paddingVertical + pointVCS.y) / content.scaleY
         );
      }
      
      
      protected function contentToViewport(pointCCS:Point) : Point
      {
         return new Point(
            pointCCS.x * content.scaleX + paddingHorizontal - _viewport.horizontalScrollPosition,
            pointCCS.y * content.scaleY + paddingVertical - _viewport.verticalScrollPosition
         );
      }
      
      /**
       * Coordinates of the point of the content visible in the center of the viewport in
       * <b>content coordinate space</b>
       */
      protected function centerPointViewport_CCS() : Point {
         return viewportToContent(new Point(width / 2, height / 2));
      }
      
      /**
       * Coordinates of the top-left corner of the content in <b>viewport coordinate space</b>. 
       */
      private function contentPosition_VCS() : Point {
         return contentToViewport(new Point(0, 0));
      }
      
      
      /* ############################# */
      /* ### GLOBAL EVENT HANDLERS ### */
      /* ############################# */
      
      
      private function addGlobalEventHandlers() : void
      {
         EventBroker.subscribe(KeyboardEvent.KEY_DOWN, global_keyDownHandler);
      }
      
      
      private function removeGlobalEventHandlers() : void
      {
         EventBroker.unsubscribe(KeyboardEvent.KEY_DOWN, global_keyDownHandler);
      }
      
      
      protected var f_keyboarControlActive:Boolean = false;
      protected function global_keyDownHandler(event:KeyboardEvent) : void
      {
         if (!f_cleanupCalled && f_keyboarControlActive)
         {
            var delta:Point;
            switch (event.keyCode)
            {
               case Keyboard.RIGHT:
                  delta = new Point(-KEYBOARD_MOVE_DELTA, 0);
                  moveContentBy(delta);
                  break;
               
               case Keyboard.LEFT:
                  delta = new Point(KEYBOARD_MOVE_DELTA, 0);
                  moveContentBy(delta);
                  break;
               
               case Keyboard.UP:
                  delta = new Point(0, KEYBOARD_MOVE_DELTA);
                  moveContentBy(delta);
                  break;
               
               case Keyboard.DOWN:
                  delta = new Point(0, -KEYBOARD_MOVE_DELTA);
                  moveContentBy(delta);
                  break;
            }
         }
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      protected function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler, true);
         addEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler, true);
         addEventListener(MouseEvent.ROLL_OUT, this_rollOutHandler, true);
         addEventListener(MouseEvent.ROLL_OVER, this_rollOverHandler, true);
         addEventListener(MouseEvent.CLICK, this_clickHandler, true);
         addEventListener(ResizeEvent.RESIZE, this_resizeHandler);
         addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
         addEventListener(FlexEvent.UPDATE_COMPLETE, this_updateCompleteHandler);
      }
      
      
      protected function removeSelfEventHandlers() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler, true);
         removeEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler, true);
         removeEventListener(MouseEvent.ROLL_OUT, this_rollOutHandler, true);
         removeEventListener(MouseEvent.ROLL_OVER, this_rollOverHandler, true);
         removeEventListener(MouseEvent.CLICK, this_clickHandler, true);
         removeEventListener(ResizeEvent.RESIZE, this_resizeHandler);
         removeEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
         removeEventListener(FlexEvent.UPDATE_COMPLETE, this_updateCompleteHandler);
      }
      
      private function this_updateCompleteHandler(event:FlexEvent) : void {
         if (f_initializeVisibleAreaTracker) {
            callContentInitialized();
         }
         else {
            callUpdateContentPosition();
            callUpdateViewportSize();
            callUpdateContentScale();
            callUpdateComplete();
         }
      }
      
      protected function this_creationCompleteHandler(event:FlexEvent) : void
      {
         centerContent();
         callContentInitialized();
      }
      
      
      protected function this_mouseDownHandler(event:MouseEvent) : void
      {
         startContentDrag(event);
      }
      
      
      protected function this_mouseUpHandler(event:MouseEvent) : void
      {
         stopContentDrag();
      }
      
      
      protected function this_rollOverHandler(event:MouseEvent) : void
      {
         f_keyboarControlActive = true;
      }
      
      
      protected function this_rollOutHandler(event:MouseEvent) : void
      {
         if (!DisplayListUtil.isInsideInstance(event.target, _content))
         {
            f_keyboarControlActive = false;
            stopContentDrag();
         }
      }
      
      
      protected function this_resizeHandler(event:ResizeEvent) : void
      {
         f_sizeChanged = true;
         invalidateDisplayList();
      }
      
      
      /**
       * This handler is used to cancel <code>CLICK</code> event (with
       * <code>event.stopImmediatePropagation()</code>) if the content has been moved between
       * <code>MOUSE_DOWN</code> and <code>MOUSE_UP</code> events.
       */
      protected function this_clickHandler(event:MouseEvent) : void
      {
         if (f_contentMoved)
         {
            f_contentMoved = false;
            event.stopImmediatePropagation();
         }
         else if (!DisplayListUtil.isInsideInstance(event.target, _contentContainer))
         {
            dispatchEvent(new ViewportEvent(ViewportEvent.CLICK_EMPTY_SPACE));
         }
      }
      
      
      /* ############################## */
      /* ### CONTENT EVENT HANDLERS ### */
      /* ############################## */
      
      
      protected function addContentEventHandlers(content:Group) : void
      {
         content.addEventListener(ResizeEvent.RESIZE, content_resizeHandler);
         content.addEventListener("scaleXChanged", content_scaleChangedHandler);
         content.addEventListener("scaleYChanged", content_scaleChangedHandler);
      }
      
      
      protected function removeContentEventHandlers(content:Group) : void
      {
         content.removeEventListener(ResizeEvent.RESIZE, content_resizeHandler);
         content.removeEventListener("scaleXChanged", content_scaleChangedHandler);
         content.removeEventListener("scaleYChanged", content_scaleChangedHandler);
      }
      
      
      protected function content_scaleChangedHandler(event:Event) : void
      {
         f_contentSizeChanged = true;
         invalidateDisplayList();
      }
      
      
      protected function content_resizeHandler(event:Event) : void
      {
         content_scaleChangedHandler(null);
      }
   }
}