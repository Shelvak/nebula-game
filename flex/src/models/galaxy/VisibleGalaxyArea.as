package models.galaxy
{
   import components.base.viewport.IVisibleAreaTrackerClient;
   
   import flash.geom.Rectangle;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import utils.Objects;
   
   
   public class VisibleGalaxyArea implements IVisibleAreaTrackerClient
   {
      private var _galaxy:Galaxy;
      
      public function VisibleGalaxyArea(galaxy:Galaxy) {
         _galaxy = Objects.paramNotNull("galaxy", galaxy);
      }
      
      private const _visibleObjects:ArrayCollection = new ArrayCollection();
      public function get visibleObjects() : IList {
         return _visibleObjects;
      }
      
      
      /* ################################# */
      /* ### IVisibleAreaTrackerClient ### */
      /* ################################# */
      
      public function areaShown(area:Rectangle) : void {
      }
      
      public function areaHidden(area:Rectangle) : void {
      }
   }
}