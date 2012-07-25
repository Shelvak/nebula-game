package models.galaxy
{
   import components.map.space.galaxy.entiregalaxy.MiniSS;
   import components.map.space.galaxy.entiregalaxy.MiniSSType;

   import flash.events.EventDispatcher;

   import models.galaxy.events.MEntireGalaxyEvent;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MapArea;

   import mx.collections.ArrayList;

   import namespaces.client_internal;

   import utils.Events;
   import utils.Objects;


   [Event(
      name=MEntireGalaxyEvent.RERENDER,
      type="models.galaxy.events.MEntireGalaxyEvent")]

   public class MEntireGalaxy extends EventDispatcher implements IMEntireGalaxy
   {
      private var _allSolarSystems: Array;
      private var _playerHomeSS: MiniSS;
      private var _fowEntries: Vector.<MapArea>;

      public function MEntireGalaxy(
         fowEntries: Vector.<MapArea>, solarSystems: Array, playerHomeSS: MiniSS)
      {
         _fowEntries = Objects.paramNotNull("fowEntries", fowEntries);
         _playerHomeSS = Objects.paramNotNull("playerHomeSS", playerHomeSS);
         _allSolarSystems = Objects.paramNotNull("allSolarSystems", solarSystems);

         _renderedObjectTypes.push(
            new MRenderedFowLine(this),
            newRenderedSS(MiniSSType.PLAYER_HOME),
            newRenderedSS(MiniSSType.ALLIANCE_HOME),
            newRenderedSS(MiniSSType.NAP_HOME),
            newRenderedSS(MiniSSType.ENEMY_HOME),
            newRenderedSS(MiniSSType.REGULAR),
            newRenderedSS(MiniSSType.PULSAR),
            newRenderedSS(MiniSSType.WORMHOLE));
      }
      
      public function get playerHomeSS(): MiniSS {
         return _playerHomeSS;
      }

      public function get fowMatrix(): FOWMatrix {
         const locations: Array = solarSystems.map(
            function (ss: MiniSS, index: int, array: Array): LocationMinimal {
               return new LocationMinimal(LocationType.GALAXY, 1, ss.x, ss.y);
            });
         return new FOWMatrix(
            1, renderFowLine ? _fowEntries : new Vector.<MapArea>(), locations, new ArrayList());
      }

      public function get solarSystems(): Array {
         const typesToRender: Object = new Object();
         for each (var renderedSS: MRenderedSS in renderedObjectTypes.slice(1)) {
            if (renderedSS.rendered) {
               typesToRender[renderedSS.type] = true;
            }
         }
         const solarSystemsToRender: Array = new Array();
         for each (var ss: MiniSS in _allSolarSystems) {
            if (typesToRender[ss.type]) {
               solarSystemsToRender.push(ss);
            }
         }
         return solarSystemsToRender;
      }

      client_internal var needsRerender: Boolean = false;
      public function rerender(): void {
         client_internal::needsRerender = true;
      }
      
      public function doRerender(): void {
         if (client_internal::needsRerender) {
            Events.dispatchSimpleEvent(this, MEntireGalaxyEvent, MEntireGalaxyEvent.RERENDER);
            client_internal::needsRerender = false;
         }
      }

      private const _renderedObjectTypes: Array = new Array();
      public function get renderedObjectTypes(): Array {
         return _renderedObjectTypes;
      }

      public function get renderFowLine(): Boolean {
         return MRenderedFowLine(renderedObjectTypes[0]).rendered;
      }


      function newRenderedSS(type: String): MRenderedSS {
         return new MRenderedSS(this, type);
      }
   }
}
