package models.planet
{
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   
   import models.BaseModel;
   import models.planet.events.PlanetObjectEvent;
   import models.tile.Tile;
   
   
   /**
    * Dispatched when any of positioning properties - and as a result dimension
    * (size) properties - have changed.
    * 
    * @eventType models.planet.events.PlanetObjectEvent.DIMENSION_CHANGE
    */
   [Event(name="dimensionChange", type="models.planet.events.PlanetObjectEvent")]
   
   /**
    * Dispatched when <code>imageData</code> property (and as a result
    * <code>imageWidth</code> and <code>imageHeight</code> properties)
    * of <code>PlanetObject</code> changes.
    * 
    * @eventType models.planet.events.PlanetObjectEvent.IMAGE_CHANGE
    */
   [Event(name="imageChange", type="models.planet.events.PlanetObjectEvent")]
   
   /**
    * Dispatched when <code>x</code> or <code>y</code> properties change:
    * as a result <code>zIndex</code> properties also change.
    * 
    * @eventType models.planet.events.PlanetObjectEvent.ZINDEX_CHANGE
    */
   [Event(name="zindexChange", type="models.planet.events.PlanetObjectEvent")]
   
   
   /**
    * Base class for any planet object. This is abstract class and you should
    * not create instances of this class. You <code>must</code> subclass it. 
    */
   public class PlanetObject extends BaseModel
   {
      /**
       * Calculates real width of object's basment.
       * 
       * @param logicalWidth object's width in number of tiles.
       * @param logicalHeight objects height in number of tiles.
       *  
       * @return width in pixels of object's basement.
       */
      public static function getRealBasementWidth(logicalWidth:int, logicalHeight:int) : Number
      {
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
      public static function getRealBasementHeight(logicalWidth:int, logicalHeight:int) : Number
      {
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
      public static function getBasementTopCorner(logicalWidth:int) : Point
      {
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
      public static function getBasementLeftCorner(logicalWidth:int) : Point
      {
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
      public static function getBasementBottomCorner(logicalWidth:int, logicalHeight:int) : Point
      {
         return new Point(
            getRealBasementWidth(logicalWidth, logicalHeight) - getBasementTopCorner(logicalWidth).x - 1,
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
      public static function getBasementRightCorner(logicalWidth:int, logicalHeight:int) : Point
      {
         return new Point(
            getRealBasementWidth(logicalWidth, logicalHeight) - 1, getRealBasementHeight(logicalWidth, logicalHeight) -
            getBasementLeftCorner(logicalWidth).y - 1
         ); 
      };
      
      
      
      
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
      public function get imageData() :BitmapData
      {
         throw new IllegalOperationError(
            "imageData is abstract property and must be overrided by subclasses!"
         );
      };
      
      
      [Bindable(event="planetObjectImageChange")]
      /**
       * Width of this object's image.
       * 
       * @default 0, if <code>imageData</code> is <code>null</code>
       */
      public function get imageWidth() : Number
      {
         return imageData ? imageData.width : 0;
      };
      
      
      [Bindable(event="planetObjectImageChange")]
      /**
       * Height of this object's image.
       * 
       * @default 0, if <code>imageData</code> is <code>null</code>
       */
      public function get imageHeight() : Number
      {
         return imageData ? imageData.height : 0;
      }
      
      
      private var _x: Number = 0;
      [Required]
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * Logical x coordinate of object's bottom corner.
       * 
       * <p>The property is marked with <code>Required</code> metadata tag.</p>
       * 
       * @default 0
       */
      public function set x(v:Number) : void
      {
         _x = v;
         dispatchDimensionChangeEvent();
         dispatchPropertyUpdateEvent("x", v);
         dispatchPropertyUpdateEvent("width", width);
      }
      /**
       * @private
       */
      public function get x() : Number
      {
         return _x;
      }
      
      
      private var _y: Number = 0;
      [Required]
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * Logical y coordinate of object's bottom corner.
       * 
       * <p>The property is marked with <code>Required</code> metadata tag.</p>
       * 
       * @default 0
       */
      public function set y(v:Number) : void
      {
         _y = v;
         dispatchDimensionChangeEvent();
         dispatchPropertyUpdateEvent("y", v);
         dispatchPropertyUpdateEvent("height", height);
      }
      /**
       * @private
       */
      public function get y() : Number
      {
         return _y;
      }
      
      
      private var _xEnd: Number = 0;
      [Required]
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * Logical x coordinate of object's top corner.
       * 
       * <p>The property is marked with <code>Required</code> metadata tag.</p>
       * 
       * @default 0
       */
      public function set xEnd(v:Number) : void
      {
         _xEnd = v;
         dispatchDimensionChangeEvent();
         dispatchPropertyUpdateEvent("xEnd", v);
         dispatchPropertyUpdateEvent("width", width);
      }
      /**
       * @private
       */
      public function get xEnd() : Number
      {
         return _xEnd;
      }
      
      
      private var _yEnd: Number = 0;
      [Required]
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * Logical y coordinate of object's top corner.
       * 
       * <p>The property is marked with <code>Required</code> metadata tag.</p>
       * 
       * @default 0
       */
      public function set yEnd(v:Number) : void
      {
         _yEnd = v;
         dispatchDimensionChangeEvent();
         dispatchPropertyUpdateEvent("yEnd", v);
         dispatchPropertyUpdateEvent("height", height);
      }
      /**
       * @private
       */
      public function get yEnd() : Number
      {
         return _yEnd;
      };
      
      
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * Logical object's height.
       * 
       * @default 1
       */
      public function get height() : Number
      {
         return yEnd - y + 1;
      };
      
      
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * Logical object's width.
       * 
       * @default 1
       */
      public function get width() : Number
      {
         return xEnd - x + 1;
      };
      
      
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * Real image's basement height in pixels.  
       */      
      public function get realBasementHeight() :Number
      {
         return getRealBasementHeight(width, height);
      };
      
      
      [Bindable(event="planetObjectDimensionChange")]
      /**
       * Real image's basement width in pixels. 
       */      
      public function get realBasementWidth() : Number
      {
         return getRealBasementWidth(width, height);
      }
      
      
      private var _zIndex:Number = -1;
      [SkipProperty]
      [Bindable(event="planetObjectZIndexChange")]
      /**
       * Objects deapth value: the smaller the result, the further this object
       * is from the bottom of a map and is overlapped by other objects with higher
       * <code>zIndex</code> value next to this one.
       * 
       * @default -1
       */
      public function set zIndex(value:Number) : void
      {
         if (_zIndex != value)
         {
            _zIndex = value;
            dispatchZIndexChangeEvent();
            dispatchPropertyUpdateEvent("zIndex", value);
         }
      }
      /**
       * @private
       */
      public function get zIndex() : Number
      {
         return _zIndex;
      }
      
      
      /**
       * If <code>true</code>, it means that this object will block
       * construction of new buildings in it's area. This is an abstract
       * property and you <strong>must</strong> implement it.
       */
      public function get isBlocking() : Boolean
      {
         throw new IllegalOperationError("isBlocking property is abstract!");
      }
      
      
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Sets the size of this planet object: modifies <code>xEnd</code> and <code>yEnd</code>
       * properties and leaves <code>x</code> and <code>y</code> properties intact.
       * 
       * @param width New width.
       * @param height New height.
       */
      public function setSize(width:int, height:int) : void
      {
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
      public function fallsIntoArea(xMin:int, xMax:int, yMin:int, yMax:int) : Boolean
      {
         if (xEnd < xMin || x > xMax ||
             yEnd < yMin || y > yMax)
         {
            return false;
         }
         return true;
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
      public function standsOn(x:int, y:int) : Boolean
      {
         return this.x <= x && x <= this.xEnd &&
                this.y <= y && y <= this.yEnd;
      }
      
      
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      /**
       * Invoke this to dispatch <code>PlanetObjectEvent.IMAGE_CHANGE</code>
       * event when the image changes. You have to invoke this method
       * manually in any derriving class.
       */
      protected function dispatchImageChangeEvent() : void
      {
         dispatchEvent(new PlanetObjectEvent(PlanetObjectEvent.IMAGE_CHANGE));
      }
      
      
      /**
       * Set this to <code>true</code> if you are about to update a few or
       * all of dimension properties (<code>x</code>, <code>y</code>,
       * <code>xEnd</code>, <code>yEnd</code>) to avoid multiple
       * <code>PlanetObjectEvent.DIMENSION_CHANGE</code> events. However, if you
       * do so, you must set this property to <code>false</code> again
       * and invoke <code>dispatchDimensionChangeEvent()</code> manually.
       */
      protected var suppressDimensionChangeEvent:Boolean = false;
      /**
       * Invoked this to dispatch <code>PlanetObjectEvent.DIMENSION_CHANGE</code>
       * event. This method is autommaticly invoked by <code>PlanetObject</code>
       * class.
       */
      protected function dispatchDimensionChangeEvent() : void
      {
         if (!suppressDimensionChangeEvent && hasEventListener(PlanetObjectEvent.DIMENSION_CHANGE))
         {
            dispatchEvent(new PlanetObjectEvent(PlanetObjectEvent.DIMENSION_CHANGE));
         }
         dispatchPropertyUpdateEvent("realBasementHeight", realBasementHeight);
         dispatchPropertyUpdateEvent("realBasementWidth", realBasementWidth);
      }
      
      
      /**
       * Set this to <code>true</code> if you are about to update both -
       * <code>x</code> and <code>y</code> - properties to avoid multiple
       * <code>PlanetObjectEvent.ZINDEX_CHANGE</code> events. However, if you
       * do so, you must set this property to <code>false</code> again
       * and invoke <code>dispatchZIndexChangeEvent()</code> manually.
       */
      protected var suppressZIndexChangeEvent:Boolean = false;
      /**
       * Invoked this to dispatch <code>PlanetObjectEvent.ZINDEX_CHANGE</code>
       * event. This method is autommaticly invoked by <code>PlanetObject</code>
       * class.
       */
      protected function dispatchZIndexChangeEvent() : void
      {
         if (!suppressZIndexChangeEvent && hasEventListener(PlanetObjectEvent.ZINDEX_CHANGE))
         {
            dispatchEvent(new PlanetObjectEvent(PlanetObjectEvent.ZINDEX_CHANGE));
         }
      }
   }
}