package components.map.space
{
   import components.gameobjects.solarsystem.SolarSystemTile;
   import components.map.space.CMapSpace;
   import components.map.space.GridGalaxy;
   
   import ext.flex.mx.collections.ArrayCollection;
   
   import models.BaseModel;
   import models.Galaxy;
   import models.events.GalaxyEvent;
   import models.map.Map;
   import models.solarsystem.SolarSystem;
   
   import namespaces.map_internal;
   
   import spark.components.Group;
   
   
   use namespace map_internal;
   
   
   /**
    * Galaxy map.
    */
   public class CMapGalaxy extends CMapSpace
   {
      /* ############### */
      /* ### OBJECTS ### */
      /* ############### */
      
      
      /**
       * List of all <code>SSTile</code> components on the map.
       */
      private var _solarSystems:ArrayCollection;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function CMapGalaxy(model:Galaxy)
      {
         super(model);
      }
      
      
      override protected function createGrid() : void
      {
         grid = new GridGalaxy(this);
      }
      
      
      protected override function createStaticObjects(objectsContainer:Group) : void
      {
         _solarSystems = new ArrayCollection();
         for each (var solarSystem:SolarSystem in getGalaxy().solarSystems)
         {
            createSolarSystemTile(solarSystem);
         }
      }
      
      
      private function createSolarSystemTile(solarSystem:SolarSystem) : void
      {
         var tile:SolarSystemTile = new SolarSystemTile();
         tile.model = solarSystem;
         _solarSystems.addItem(tile);
         staticObjectsContainer.addElement(tile);
      }
      
      
      private function removeSolarSystemTile(solarSystem:SolarSystem) : void
      {
         var tile:SolarSystemTile = getSolarSystemTileByModel(solarSystem);
         _solarSystems.removeItem(tile);
         staticObjectsContainer.removeElement(tile);
      }
      
      
      /* ############################## */
      /* ### SOLAR SYSTEM SELECTION ### */
      /* ############################## */
      
      
      protected override function selectModel(object:BaseModel) : void
      {
         if (object is SolarSystem)
         {
            getSolarSystemTileByModel(SolarSystem(object)).select();
         }
      }
      
      
      /**
       * Typed getter for <code>model</code> property.
       */
      public function getGalaxy() : Galaxy
      {
         return Galaxy(model);
      }
      
      
      /**
       * Finds and returns a solar system tile component that represent the given solar system model.
       * 
       * @param solarSystem A model of a component to look.
       * 
       * @return A <code>SolarSystemTile</code> instance that represents the given
       * <code>solarSystem</code> or <code>null</code> if one can't be found.
       */
      protected function getSolarSystemTileByModel(solarSystem:SolarSystem) : SolarSystemTile
      {
         for each (var tile:SolarSystemTile in _solarSystems)
         {
            if (tile.model.equals(solarSystem))
            {
               return tile;
            }
         }
         return null;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      protected override function addModelEventHandlers(model:Map) : void
      {
         super.addModelEventHandlers(model);
         var g:Galaxy = Galaxy(model);
         g.addEventListener(GalaxyEvent.RESIZE, model_resizeHandler);
         g.addEventListener(GalaxyEvent.SOLAR_SYSTEM_ADD, model_solarSystemAddHandler);
         g.addEventListener(GalaxyEvent.SOLAR_SYSTEM_REMOVE, model_solarSystemRemoveHandler);
      }
      
      
      protected override function removeModelEventHandlers(model:Map) : void
      {
         var g:Galaxy = Galaxy(model);
         g.removeEventListener(GalaxyEvent.RESIZE, model_resizeHandler);
         g.removeEventListener(GalaxyEvent.SOLAR_SYSTEM_ADD, model_solarSystemAddHandler);
         g.removeEventListener(GalaxyEvent.SOLAR_SYSTEM_REMOVE, model_solarSystemRemoveHandler);
         super.removeModelEventHandlers(model);
      }
      
      
      private function model_resizeHandler(event:GalaxyEvent) : void
      {
         invalidateSize();
         invalidateDisplayList();
      }
      
      
      private function model_solarSystemAddHandler(event:GalaxyEvent) : void
      {
         createSolarSystemTile(event.solarSystem);
      }
      
      
      private function model_solarSystemRemoveHandler(event:GalaxyEvent) : void
      {
         removeSolarSystemTile(event.solarSystem);
      }
   }
}