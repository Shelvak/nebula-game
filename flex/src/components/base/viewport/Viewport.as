package components.base.viewport
{
   import components.base.ScrollerVariableScrollStep;
   import components.base.viewport.events.ViewportEvent;
   
   import ext.flex.mx.collections.ArrayCollection;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import mx.core.IVisualElement;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.MoveEvent;
   import mx.events.ResizeEvent;
   
   import spark.components.Group;
   import spark.components.HScrollBar;
   import spark.components.Scroller;
   import spark.components.SkinnableContainer;
   import spark.components.VScrollBar;
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
   public class Viewport extends SkinnableContainer
   {
      private static const MOVE_EFFECT_DURATION:Number = 500;
      private static const SCROLL_STEP_MULTIPLYER:Number = 10;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      private var _contentScrollAnimator:Animate;
      private var _underlayScrollAnimator:Animate;
      
      
      /**
       * Constructor.
       */
      public function Viewport()
      {
         super();
         _contentScrollAnimator = new Animate();
         _underlayScrollAnimator = new Animate();
         _contentScrollAnimator.duration =
         _underlayScrollAnimator.duration = MOVE_EFFECT_DURATION;
         addSelfEventHandlers();
      }
      
      
      public function cleanup() : void
      {
         removeSelfEventHandlers();
         if (_contentScrollAnimator)
         {
            _contentScrollAnimator.stop();
            _contentScrollAnimator.target = null;
            _contentScrollAnimator = null;
         }
         if (_underlayScrollAnimator)
         {
            _underlayScrollAnimator.stop();
            _underlayScrollAnimator.target = null;
            _underlayScrollAnimator = null;
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
         overlay = null;
         underlayElement = null;
         _contentContainer = null;
         _scrollerViewport = null;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _contentContainer:Group;
      private var _scrollerViewport:Group;
      private var _scroller:ScrollerVariableScrollStep;
      private var _underlayContentContainer:Group;
      private var _underlayScrollerViewport:Group;
      private var _underlayScroller:Scroller;
      
      
      private var f_childrenCreated:Boolean = false;
      
      protected override function createChildren() : void
      {
         _contentContainer = new Group();
         _contentContainer.mouseEnabled = false;
         _scrollerViewport = new Group();
         _scrollerViewport.addElement(_contentContainer);
         _scrollerViewport.mouseEnabled = false;
         _contentScrollAnimator.target = _scrollerViewport;
         _scroller = new ScrollerVariableScrollStep();
         _scroller.left =
         _scroller.right =
         _scroller.top =
         _scroller.bottom = 0;
         _scroller.viewport = _scrollerViewport;
         
         _underlayContentContainer = new Group();
         _underlayScrollerViewport = new Group();
         _underlayScrollerViewport.addElement(_underlayContentContainer);
         _underlayScroller = new Scroller();
         _underlayScroller.left =
         _underlayScroller.right =
         _underlayScroller.top =
         _underlayScroller.bottom = 0;
         _underlayScroller.viewport = _underlayScrollerViewport;
         _underlayScroller.mouseEnabled =
         _underlayScroller.mouseChildren = false;
         _underlayScroller.setStyle("horizontalScrollPolicy", ScrollPolicy.OFF);
         _underlayScroller.setStyle("verticalScrollPolicy", ScrollPolicy.OFF);
         
         super.createChildren();
      }
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         if (instance == contentGroup)
         {
            contentGroup.mouseEnabled = false;
            contentGroup.clipAndEnableScrolling = true;
            contentGroup.addElement(_underlayScroller);
            contentGroup.addElement(_scroller);
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
            invalidateDisplayList();
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
         return _underlayElement != null;
      }
      
      
      private var _underlayElement:IVisualElement;
      public function set underlayElement(value:IVisualElement) : void
      {
         if (_underlayElement != value)
         {
            _underlayElement = value;
            f_underlayElementChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get underlayElement() : IVisualElement
      {
         return _underlayElement;
      }
      
      
      private function installUnderlayElement(underlay:IVisualElement) : void
      {
         underlay.left =
         underlay.right =
         underlay.top =
         underlay.bottom = 0;
         _underlayContentContainer.addElement(underlay);
         invalidateUnderlaySize();
         invalidateUnderlayScrollPosition();
      }
      
      
      private function uninstallCurrentUnderlayElement() : void
      {
         _underlayContentContainer.removeAllElements();
         invalidateUnderlaySize();
         invalidateUnderlayScrollPosition();
      }
      
      
      private var f_underlaySizeInvalid:Boolean = true;
      private function invalidateUnderlaySize() : void
      {
         if (!f_underlaySizeInvalid)
         {
            f_underlaySizeInvalid = true;
            invalidateDisplayList();
         }
      }
      private function validateUnderlaySize() : void
      {
         if (!haveUnderlay || !_content)
         {
            return;
         }
         var w:Number = (content.width + paddingHorizontal * 2) * _underlayScrollSpeedRatio;
         var h:Number = (content.height + paddingHorizontal * 2) * _underlayScrollSpeedRatio;
         w = w < _contentContainer.width ? _contentContainer.width : w;
         h = h < _contentContainer.height ? _contentContainer.height : h;
         _underlayContentContainer.width = w;
         _underlayContentContainer.height = h;
         f_underlaySizeInvalid = false;
      }
      
      
      private var f_underlayScrollPositionInvalid:Boolean = true;
      private function invalidateUnderlayScrollPosition() : void
      {
         if (!f_underlayScrollPositionInvalid)
         {
            f_underlayScrollPositionInvalid = true;
            invalidateDisplayList();
         }
      }
      private function validateUnderlayScrollPosition() : void
      {
         if (!haveUnderlay || !_content)
         {
            return;
         }
         var hsb:Number = _scrollerViewport.horizontalScrollPosition * _underlayScrollSpeedRatio;
         var vsb:Number = _scrollerViewport.verticalScrollPosition * _underlayScrollSpeedRatio;
         _underlayScrollerViewport.horizontalScrollPosition = hsb;
         _underlayScrollerViewport.verticalScrollPosition = vsb;
         f_underlayScrollPositionInvalid = false;
      }
      
      
      private var f_underlayScaleInvalid:Boolean = true;
      private function invalidateUnderlayScale() : void
      {
         if (!f_underlayScaleInvalid)
         {
            f_underlayScaleInvalid = true;
            invalidateUnderlayScrollPosition();
         }
      }
      private function validateUnderlayScale() : void
      {
         if (!haveUnderlay || !_content)
         {
            return;
         }
         var scaleX:Number = 1 - (1 - _content.scaleX) * _underlayScrollSpeedRatio;
         var scaleY:Number = 1 - (1 - _content.scaleY) * _underlayScrollSpeedRatio;
         _underlayContentContainer.scaleX = scaleX;
         _underlayContentContainer.scaleY = scaleY;
         f_underlayScaleInvalid = false;
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
            f_underlayScrollSpeedRatioChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get underlayScrollSpeedRatio() : Number
      {
         return _underlayScrollSpeedRatio;
      }
      
      
      private var _useScrollBars:Boolean = false;
      /**
       * Indicates if scroll bars should be visible
       */
      public function set useScrollBars(value:Boolean) : void
      {
         if (_useScrollBars != value)
         {
            _useScrollBars = value;
            f_useScrollBarsChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get useScrollBars() : Boolean
      {
         return _useScrollBars;
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
            invalidateDisplayList();
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
            invalidateUnderlaySize();
            invalidateDisplayList();
         }
      }
      /**
       * @private 
       */
      public function get paddingVertical() : uint
      {
         return _paddingVertical;
      }
      
      
      private var f_contentChanged:Boolean = true;
      private var f_useScrollBarsChanged:Boolean = true;
      private var f_overlayChanged:Boolean = true;
      private var f_underlayElementChanged:Boolean = true;
      private var f_underlayScrollSpeedRatioChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
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
               installContent(_content);
            }
            dispatchEvent(event);
         }
         
         if (f_useScrollBarsChanged)
         {
            if (_useScrollBars)
            {
               _scroller.stepMultiplyer = SCROLL_STEP_MULTIPLYER;
               _scroller.setStyle("horizontalScrollPolicy", ScrollPolicy.AUTO);
               _scroller.setStyle("verticalScrollPolicy", ScrollPolicy.AUTO);
            }
            else
            {
               _scroller.stepMultiplyer = 1;
               _scroller.setStyle("horizontalScrollPolicy", ScrollPolicy.OFF);
               _scroller.setStyle("verticalScrollPolicy", ScrollPolicy.OFF);
            }
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
         
         if (f_underlayElementChanged)
         {
            uninstallCurrentUnderlayElement();
            if (_underlayElement)
            {
               installUnderlayElement(_underlayElement);
            }
         }
         
         if (f_underlayScrollSpeedRatioChanged)
         {
            invalidateUnderlaySize();
            invalidateUnderlayScrollPosition();
         }
         
         f_contentChanged = false;
         f_useScrollBarsChanged = false;
         f_overlayChanged = false;
         f_underlayElementChanged = false;
         f_underlayScrollSpeedRatioChanged = false;
      }
      
      
      private var f_paddingChanged:Boolean = true;
      private var f_contentSizeChanged:Boolean = true;
      private var f_sizeChanged:Boolean = true;
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         
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
            f_paddingChanged = f_contentSizeChanged = f_sizeChanged = false;
            dispatchEvent(new ViewportEvent(ViewportEvent.CONTENT_RESIZE));
         }
         if (f_underlaySizeInvalid)
         {
            validateUnderlaySize();
         }
         if (f_underlayScaleInvalid)
         {
            validateUnderlayScale();
         }
         if (f_underlayScrollPositionInvalid)
         {
            validateUnderlayScrollPosition();
         }            
      }
      
      
      /* ############################# */
      /* ### MOVING CONTENT AROUND ### */
      /* ############################# */
      
      
      /**
       * Centers content in the viewport. 
       */      
      public function centerContent() : void
      {
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
         if (!_content)
         {
            return;
         }
         delta.x = delta.x * content.scaleX;
         delta.y = delta.y * content.scaleY;
         if (useAnimation)
         {
            _contentScrollAnimator.end();
            var paths:Vector.<MotionPath> = new Vector.<MotionPath>();
            var startKeyframeHSP:Keyframe = new Keyframe(0, _scrollerViewport.horizontalScrollPosition);
            var endKeyframeHSP:Keyframe = new Keyframe(_contentScrollAnimator.duration, null, - delta.x);
            paths.push(new MotionPath("horizontalScrollPosition"));
            paths[0].keyframes = Vector.<Keyframe>([startKeyframeHSP, endKeyframeHSP]);
            var startKeyframeVSP:Keyframe = new Keyframe(0, _scrollerViewport.verticalScrollPosition);
            var endKeyframeVSP:Keyframe = new Keyframe(_contentScrollAnimator.duration, null, - delta.y);
            paths.push(new MotionPath("verticalScrollPosition"));
            paths[1].keyframes = Vector.<Keyframe>([startKeyframeVSP, endKeyframeVSP]);
            _contentScrollAnimator.motionPaths = paths;
            function effectUpdateHandler(event:EffectEvent) : void
            {
               validateUnderlayScrollPosition();
            }
            function effectEndHandler(event:EffectEvent) : void
            {
               _contentScrollAnimator.removeEventListener(EffectEvent.EFFECT_END, effectEndHandler);
               _contentScrollAnimator.removeEventListener(EffectEvent.EFFECT_UPDATE, effectUpdateHandler);
               updateScrollPosition(new Point(
                  _scrollerViewport.horizontalScrollPosition,
                  _scrollerViewport.verticalScrollPosition
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
            updateScrollPosition(new Point(
               _scrollerViewport.horizontalScrollPosition - delta.x,
               _scrollerViewport.verticalScrollPosition - delta.y
            ));
         }
      }
      
      
      /**
       * Moves the content to a given coordinates (ensures these coordinates appear
       * at the center of a viewport or at least are visible if bounds of the
       * content container are reached). Given coordinates must be in content's coordinate space.
       */      
      public function moveContentTo(point:Point, useAnimation:Boolean = false, animationCompleteHandler:Function = null) : void
      {
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
         if (!_content ||
             DisplayListUtil.isInsideType(event.target, VScrollBar) ||
             DisplayListUtil.isInsideType(event.target, HScrollBar))
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
         if (_content && f_contentOnDrag && event.buttonDown)
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
         f_contentOnDrag = false;
         removeEventListener(MouseEvent.MOUSE_MOVE, doContentDrag);
      }
      
      
      private function updateScrollPosition(position:Point) : void
      {
         _scrollerViewport.horizontalScrollPosition = position.x;
         _scrollerViewport.verticalScrollPosition = position.y;
         var contentMoveEvent:ViewportEvent = new ViewportEvent(ViewportEvent.CONTENT_MOVE);
         contentMoveEvent.contentPosition = new Point(
            paddingHorizontal - _scrollerViewport.horizontalScrollPosition,
            paddingVertical - _scrollerViewport.verticalScrollPosition
         );
         validateUnderlayScrollPosition();
         dispatchEvent(contentMoveEvent);     
      }
      
      
      /* ############################################################# */
      /* ### COORDINATES IN VIEWPORT AND CONTENT CORRDINATE SPACES ### */
      /* ############################################################# */
      
      
      protected function viewportToContent(pointVCS:Point) : Point
      {
         return new Point(
            (_scrollerViewport.horizontalScrollPosition - paddingHorizontal + pointVCS.x) / content.scaleX,
            (_scrollerViewport.verticalScrollPosition - paddingVertical + pointVCS.y) / content.scaleY
         );
      }
      
      
      protected function contentToViewport(pointCCS:Point) : Point
      {
         return new Point(
            pointCCS.x * content.scaleX + paddingHorizontal - _scrollerViewport.horizontalScrollPosition,
            pointCCS.y * content.scaleY + paddingVertical - _scrollerViewport.verticalScrollPosition
         );
      }
      
      
      /**
       * Coordinates of the point of the content visible in the center of the viewport in
       * <strong>Content Coordinate Space</strong>
       */
      protected function centerPointViewport_CCS() : Point
      {
         return viewportToContent(new Point(width / 2, height / 2));
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      protected function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler, true);
         addEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler, true);
         addEventListener(MouseEvent.ROLL_OUT, this_rollOutHandler, true);
         addEventListener(MouseEvent.CLICK, this_clickHandler, true);
         addEventListener(MouseEvent.MOUSE_WHEEL, this_mouseWheelHandler, true);
         addEventListener(ResizeEvent.RESIZE, this_resizeHandler);
         addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
      }
      
      
      protected function removeSelfEventHandlers() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
         removeEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);
         removeEventListener(MouseEvent.ROLL_OUT, this_rollOutHandler);
         removeEventListener(MouseEvent.CLICK, this_clickHandler);
         removeEventListener(MouseEvent.MOUSE_WHEEL, this_mouseWheelHandler);
         removeEventListener(ResizeEvent.RESIZE, this_resizeHandler);
         removeEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
      }
      
      
      protected function this_creationCompleteHandler(event:FlexEvent) : void
      {
         centerContent();
      }
      
      
      protected function this_mouseDownHandler(event:MouseEvent) : void
      {
         startContentDrag(event);
      }
      
      
      protected function this_mouseUpHandler(event:MouseEvent) : void
      {
         stopContentDrag();
      }
      
      
      protected function this_rollOutHandler(event:MouseEvent) : void
      {
         stopContentDrag();
      }
      
      
      protected function this_resizeHandler(event:ResizeEvent) : void
      {
         f_sizeChanged = true;
         invalidateDisplayList();
      }
      
      
      /**
       * If <code>useScrollBars</code> is <code>false</code>, will prevent scroll bars from
       * handling the event (by calling <code>event.preventDefault()</code>). This handler is
       * called during capturing phase.
       */
      protected function this_mouseWheelHandler(event:MouseEvent) : void
      {
         if (!useScrollBars)
         {
            event.preventDefault();
         }
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
         else if (event.target == this)
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
         invalidateUnderlayScale();
         invalidateUnderlaySize();
         invalidateDisplayList();
      }
      
      
      protected function content_resizeHandler(event:Event) : void
      {
         content_scaleChangedHandler(null);
      }
   }
}