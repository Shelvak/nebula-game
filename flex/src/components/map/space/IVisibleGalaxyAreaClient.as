package components.map.space
{
   import models.map.IMStaticSpaceObject;

   /**
    * Defines interface for galaxy map that uses <code>VisibleGalaxyArea</code> to track visible sectors
    * of a galaxy. 
    */
   public interface IVisibleGalaxyAreaClient
   {
      function sectorShown(x:int, y:int) : void;
      function sectorHidden(x:int, y:int) : void;
   }
}