package models.planet.events
{
   import flash.events.Event;
   
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   
   public class MPlanetObjectEvent extends Event
   {
      /**
       * Dispatched when <code>imageData</code> property (and as a result
       * <code>imageWidth</code> and <code>imageHeight</code> properties)
       * of <code>MPlanetObject</code> changes.
       * 
       * @eventType planetObjectImageChange
       */
      public static const IMAGE_CHANGE:String = "planetObjectImageChange";
      
      
      /**
       * Dispatched when <code>x</code>, <code>y</code>, <code>xEnd</code> or
       * <code>yEnd</code> properties of <code>MPlanetObject</code> change:
       * as a result of this change <code>width</code>, <code>height</code>,
       * <code>realBasementWidth</code> and <code>realBasementHeight</code>
       * properties also change.
       * 
       * @eventType planetObjectDimensionChange
       */
      public static const DIMENSION_CHANGE:String = "planetObjectDimensionChange";
      
      
      /**
       * Dispatched when <code>x</code> or <code>y</code> of
       * <code>MPlanetObject</code> change: <code>zIndex</code> properties also
       * change.
       * 
       * @eventType planetObjectZIndexChange
       */
      public static const ZINDEX_CHANGE:String = "planetObjectZIndexChange";
      
      
      /**
       * Typed alias for <code>target</code> property.
       */
      public function get planetObject() : MPlanetObject
      {
         return target as MPlanetObject;
      }
      
      
      /**
       * Constructor.
       */
      public function MPlanetObjectEvent(type:String)
      {
         super(type, false, false);
      }
   }
}