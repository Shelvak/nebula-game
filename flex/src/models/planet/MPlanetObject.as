package models.planet
{
   import flash.display.BitmapData;
   import flash.geom.Point;

   import models.BaseModel;
   import models.planet.events.MPlanetObjectEvent;
   import models.tile.Tile;

   import utils.Events;
   import utils.Objects;


   /**
    * Dispatched when <code>imageData</code> property (and as a result
    * <code>imageWidth</code> and <code>imageHeight</code> properties)
    * of <code>MPlanetObject</code> changes.
    * 
    * @eventType models.planet.events.MPlanetObjectEvent.IMAGE_CHANGE
    */
   [Event(name="imageChange", type="models.planet.events.MPlanetObjectEvent")]

   /**
    * Dispatched when <code>zIndex</code> property has changed change.
    * 
    * @eventType models.planet.events.MPlanetObjectEvent.ZINDEX_CHANGE
    */
   [Event(name="zindexChange", type="models.planet.events.MPlanetObjectEvent")]

   /**
    * Base class for any planet object. This is abstract class and you should
    * not create instances of this class. You <code>must</code> subclass it. 
    */
   public class MPlanetObject extends BaseModel
   {
      /**
       * Calculates real width of object's basment.
       * 
       * @param logicalWidth object's width in number of tiles.
       * @param logicalHeight objects height in number of tiles.
       *  
       * @return width in pixels of object's basement.
       */
      public static function getRealBasementWidth(logicalWidth: int,
                                                  logicalHeight: int): Number {
         return (logicalHeight + logicalWidth) * (Tile.IMAGE_WIDTH / 2 + 1) - 2;
      }


      /**
       * Calculates real height of object's basment.
       *
       * @param logicalWidth object's width in number of tiles.
       * @param logicalHeight objects height in number of tiles.
       *
       * @return height in pixels of object's basement.
       */
      public static function getRealBasementHeight(logicalWidth: int,
                                                   logicalHeight: int): Number {
         return (logicalWidth + logicalHeight) * Tile.IMAGE_HEIGHT / 2
      }
      
      /**
       * Calculates and returns coordinates of basement's top-most corner. Coordinates
       * of the left pixel of the corner are returned.
       * 
       * @param logicalWidth object's width in number of tiles.
       * 
       * @return instance of <code>SimplePoint</code>
       */
      public static function getBasementTopCorner(logicalWidth: int): Point {
         return new Point((Tile.IMAGE_WIDTH / 2 + 1) * logicalWidth - 1, 0);
      }

      /**
       * Calculates and returns coordinates of basement's left-most corner. Coordinates
       * of the top pixel of the corner are returned.
       *
       * @param logicalWidth object's width in number of tiles.
       *
       * @return instance of <code>SimplePoint</code>
       */
      public static function getBasementLeftCorner(logicalWidth: int): Point {
         return new Point(0, logicalWidth * Tile.IMAGE_HEIGHT / 2);
      }
      
      /**
       * Calculates and returns coordinates of basement's bottom-most corner. Coordinates
       * of the left pixel of the corner are returned.
       * 
       * @param logicalWidth object's width in number of tiles.
       * @param logicalHeight objects height in number of tiles.
       * 
       * @return instance of <code>SimplePoint</code>
       */
      public static function getBasementBottomCorner(logicalWidth: int,
                                                     logicalHeight: int): Point {
         return new Point(
            getRealBasementWidth(logicalWidth, logicalHeight)
               - getBasementTopCorner(logicalWidth).x - 1,
            getRealBasementHeight(logicalWidth, logicalHeight) - 1
         );
      }

      /**
       * Calculates and returns coordinates of basement's right-most corner. Coordinates
       * of the top pixel of the corner are returned.
       * 
       * @param logicalWidth object's width in number of tiles.
       * @param logicalHeight objects height in number of tiles.
       * 
       * @return instance of <code>SimplePoint</code> 
       */
      public static function getBasementRightCorner(logicalWidth: int,
                                                    logicalHeight: int): Point {
         return new Point(
            getRealBasementWidth(logicalWidth, logicalHeight) - 1,
            getRealBasementHeight(logicalWidth, logicalHeight)
               - getBasementLeftCorner(logicalWidth).y - 1
         );
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      [Bindable(event="planetObjectImageChange")]
      /**
       * Data of the image that represents this object on the planet. This is
       * an abstract property and <strong>must</strong> be overrided by
       * any subclass.
       * 
       * <p><strong>Important</strong>: you have to manually call
       * <code>dispatchImageChangeEvent()</code> method when the image was
       * changed. Otherwise binding for <code>imageData, imageWidth</code>
       * and <code>imageHeight</code> properties won't work.</p>
       */
      public function get imageData() : BitmapData {
         Objects.throwAbstractPropertyError();
         return null;   // unreachable
      }

      [Bindable(event="planetObjectImageChange")]
      /**
       * Width of this object's image.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="planetObjectImageChange")]
       * </p>
       * 
       * @default 0, if <code>imageData</code> is <code>null</code>
       */
      public function get imageWidth(): Number {
         return imageData ? imageData.width : 0;
      }

      [Bindable(event="planetObjectImageChange")]
      /**
       * Height of this object's image.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="planetObjectImageChange")]
       * </p>
       * 
       * @default 0, if <code>imageData</code> is <code>null</code>
       */
      public function get imageHeight(): Number {
         return imageData ? imageData.height : 0;
      }

      private var _x: Number = 0;
      [Required]
      /**
       * Logical x coordinate of object's bottom corner.
       * 
       * @default 0
       */
      public function set x(value: Number): void {
         if (_x != value) {
            _x = value;
         }
      }
      /**
       * @private
       */
      public function get x(): Number {
         return _x;
      }

      private var _y: Number = 0;
      [Required]
      /**
       * Logical y coordinate of object's bottom corner.
       * 
       * @default 0
       */
      public function set y(value: Number): void {
         if (_y != value) {
            _y = value;
         }
      }
      /**
       * @private
       */
      public function get y(): Number {
         return _y;
      }


      private var _xEnd: Number = 0;
      [Required]
      /**
       * Logical x coordinate of object's top corner.
       * 
       * @default 0
       */
      public function set xEnd(value: Number): void {
         if (_xEnd != value) {
            _xEnd = value;
         }
      }
      /**
       * @private
       */
      public function get xEnd(): Number {
         return _xEnd;
      }


      private var _yEnd: Number = 0;
      [Required]
      /**
       * Logical y coordinate of object's top corner.
       * 
       * @default 0
       */
      public function set yEnd(value: Number): void {
         if (_yEnd != value) {
            _yEnd = value;
         }
      }
      /**
       * @private
       */
      public function get yEnd(): Number {
         return _yEnd;
      }
      
      
      /**
       * Logical object's height.
       * 
       * @default 1
       */
      public function get height(): Number {
         return yEnd - y + 1;
      }
      
      
      /**
       * Logical object's width.
       * 
       * @default 1
       */
      public function get width(): Number {
         return xEnd - x + 1;
      }
      
      /**
       * Real image's basement height in pixels.
       * 
       * <p><b>No <code>PROPERTY_CHANGE</code> event.</b></p>
       */
      public function get realBasementHeight(): Number {
         return getRealBasementHeight(width, height);
      }
      
      
      /**
       * Real image's basement width in pixels.
       */
      public function get realBasementWidth(): Number {
         return getRealBasementWidth(width, height);
      }
      
      
      private var _zIndex:Number = -1;
      [SkipProperty]
      [Bindable(event="planetObjectZIndexChange")]
      /**
       * Objects depth value: the smaller the result, the further this object
       * is from the bottom of a map and is overlapped by other objects with higher
       * <code>zIndex</code> value next to this one.
       * 
       * <p>Metadata:<br/>
       * [SkipProperty]<br/>
       * [Bindable(event="planetObjectZIndexChange")]
       * </p>
       * 
       * <p><b>No <code>PROPERTY_CHANGE</code> event.</b></p>
       * 
       * @default -1
       */
      public function set zIndex(value: Number): void {
         if (_zIndex != value) {
            _zIndex = value;
            dispatchZIndexChangeEvent();
         }
      }
      /**
       * @private
       */
      public function get zIndex(): Number {
         return _zIndex;
      }
      
      
      /**
       * If <code>true</code>, it means that this object will block
       * construction of new buildings in it's area. This is an abstract
       * property and you <b>must</b> implement it.
       */
      public function get isBlocking(): Boolean {
         Objects.throwAbstractPropertyError();
         return false;  // unreachable
      }
      
      
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */

      /**
       * Changes objects position: <code>x</code> and <code>y</code> properties
       * are set to new values provided and <code>xEnd</code> and <code>yEnd</code>
       * properties are modified accordingly. This method allows you to pass
       * negative values.
       *
       * @param x
       * @param y
       *
       * @return <code>true</code> if the object was actually moved or
       * <code>false</code> otherwise.
       */
      public function moveTo(x: Number, y: Number): Boolean {
         if (x == this.x && y == this.y) {
            return false;
         }
         const w: Number = width;
         const h: Number = height;
         this.x = x;
         this.y = y;
         this.xEnd = x + w - 1;
         this.yEnd = y + h - 1;
         return true;
      }
      
      
      /**
       * Sets the size of this planet object: modifies <code>xEnd</code> and <code>yEnd</code>
       * properties and leaves <code>x</code> and <code>y</code> properties intact.
       * 
       * @param width New width.
       * @param height New height.
       */
      public function setSize(width: int, height: int): void {
         xEnd = x + width - 1;
         yEnd = y + height - 1;
      }
      
      
      /**
       * Lets you find out if this object falls into the given area. Here
       * "falls into" means that at least one coordinate (tile) is occupied by
       * this object.
       * 
       * <p>Given coordinates of area bounds are of inclusive range.</p> 
       *  
       * @param xMin
       * @param xMax
       * @param yMin
       * @param yMax
       * 
       * @return <code>true</code> if there is at least one tile that is
       * occupied by this building, <code>false</code> - otherwise.
       */
      public function fallsIntoArea(xMin: int, xMax: int,
                                    yMin: int, yMax: int): Boolean {
         return !(xEnd < xMin || x > xMax || yEnd < yMin || y > yMax);
      }
      
      
      /**
       * Determines if this object occupies the given cooridnates (tile) on
       * the map.
       * 
       * @param x X coordinate.
       * @param y Y coordinate.
       * 
       * @return <code>true</code> if object stands on the given coordinates
       * of the map or <code>false</code> otherwise.
       */
      public function standsOn(x: int, y: int): Boolean {
         return this.x <= x && x <= this.xEnd && this.y <= y && y <= this.yEnd;
      }


      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */

      /**
       * Invoke this to dispatch <code>MPlanetObjectEvent.IMAGE_CHANGE</code>
       * event when the image changes. You have to invoke this method
       * manually in any deriving class.
       */
      protected function dispatchImageChangeEvent(): void {
         Events.dispatchSimpleEvent(
            this, MPlanetObjectEvent, MPlanetObjectEvent.IMAGE_CHANGE
         );
      }

      /**
       * Set this to <code>true</code> if you want to avoid multiple
       * <code>MPlanetObjectEvent.ZINDEX_CHANGE</code> events. However, if you do so, you must
       * set this property to <code>false</code> again and invoke
       * <code>dispatchZIndexChangeEvent()</code> manually.
       */
      protected var suppressZIndexChangeEvent: Boolean = false;

      /**
       * Invoked this to dispatch <code>MPlanetObjectEvent.ZINDEX_CHANGE</code>
       * event. This method is autommaticly invoked by <code>MPlanetObject</code>
       * class.
       */
      protected function dispatchZIndexChangeEvent(): void {
         if (!suppressZIndexChangeEvent) {
            Events.dispatchSimpleEvent(
               this, MPlanetObjectEvent, MPlanetObjectEvent.ZINDEX_CHANGE
            );
         }
      }
   }
}