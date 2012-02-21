package models.map
{

   import models.BaseModel;
   import models.map.events.MMapEvent;
   import models.movement.MSquadron;
   import models.movement.events.MSquadronEvent;

   import mx.collections.ListCollectionView;

   import utils.Objects;
   import utils.datastructures.Collections;


   /**
    * Dispatched when squadron moves to another hop inside the map.
    *
    * @eventType models.map.events.MMapEvent.SQUADRON_MOVE
    */
   [Event(name="squadronMove", type="models.map.events.MMapEvent")]
   
   public class MMapSpace extends MMap
   {
      public static const STATIC_OBJECT_COOLDOWN:int = 0;
      public static const STATIC_OBJECT_NATURAL:int = 1;
      public static const STATIC_OBJECT_WRECKAGE:int = 2;
      
      public function MMapSpace() {
         super();
         _naturalObjects = Collections.filter(objects, ff_naturalObjects);
         _wreckages = Collections.filter(objects, ff_wreckages);
         _cooldowns = Collections.filter(objects, ff_cooldowns);
         addEventListener(
            MMapEvent.SQUADRON_ENTER, this_squadronEnterHandler,
            false, 0, true
         );
         addEventListener(
            MMapEvent.SQUADRON_LEAVE, this_squadronLeaveHandler,
            false, 0, true
         );
         for each (var squad:MSquadron in squadrons) {
            addSquadronEventHandler(squad);
         }
      }


      override public function cleanup(): void {
         for each (var squad:MSquadron in squadrons) {
            removeSquadronEventHandlers(squad);
         }
         super.cleanup();
      }

      private function this_squadronEnterHandler(event: MMapEvent): void {
         addSquadronEventHandler(event.squadron);
      }

      private function this_squadronLeaveHandler(event: MMapEvent): void {
         removeSquadronEventHandlers(event.squadron);
      }

      private function addSquadronEventHandler(squadron: MSquadron): void {
         Objects.paramNotNull("squadron", squadron);
         squadron.addEventListener(
            MSquadronEvent.MOVE, squadron_moveHandler, false, 0, true
         );
      }

      private function removeSquadronEventHandlers(squadron: MSquadron): void {
         Objects.paramNotNull("squadron", squadron);
         squadron.removeEventListener(
            MSquadronEvent.MOVE, squadron_moveHandler, false
         );
      }

      private function squadron_moveHandler(event: MSquadronEvent): void {
         if (hasEventListener(MMapEvent.SQUADRON_MOVE)) {
            var mapEvent:MMapEvent = new MMapEvent(MMapEvent.SQUADRON_MOVE);
            mapEvent.squadron = event.squadron;
            dispatchEvent(mapEvent);
         }
      }
      
      private var _wreckages:ListCollectionView;
      private function ff_wreckages(object:IMStaticSpaceObject) : Boolean {
         return object.objectType == STATIC_OBJECT_WRECKAGE;
      }
      [Bindable(event="willNotChange")]
      /**
       * List of all wreckages on this map (bound to <code>objects</code> collection).
       */
      public function get wreckages() : ListCollectionView {
         return _wreckages;
      }
      
      private var _naturalObjects:ListCollectionView;
      private function ff_naturalObjects(object:IMStaticSpaceObject) : Boolean {
         return object.objectType == STATIC_OBJECT_NATURAL;
      }
      [Bindable(event="willNotChange")]
      /**
       * List of all naturalObjects on this map (bound to <code>objects</code> collection).
       */
      public function get naturalObjects() : ListCollectionView {
         return _naturalObjects;
      }
      
      private var _cooldowns:ListCollectionView;
      private function ff_cooldowns(object:IMStaticSpaceObject) : Boolean {
         return object.objectType == STATIC_OBJECT_COOLDOWN;
      }
      [Bindable(event="willNotChange")]
      /**
       * List of all cooldowns on this map (bound to <code>objects</code> collection).
       */
      public function get cooldowns() : ListCollectionView {
         return _cooldowns;
      }
      
      private const _staticObjectsHash:StaticObjectsHash = new StaticObjectsHash();
      
      public override function addObject(object:BaseModel) : void {
         super.addObject(object);
         _staticObjectsHash.put(IMStaticSpaceObject(object));
      }
      
      public override function removeObject(object:BaseModel, silent:Boolean = false) : * {
         var removedObject:IMStaticSpaceObject = super.removeObject(object, silent);
         if (removedObject != null) {
            _staticObjectsHash.removeObject(removedObject);
         }
         return removedObject;
      }
      
      protected function getAllStaticObjectsAt(x:int, y:int) : Array {
         var objects:Array = new Array();
         var sectorObjects:SectorObjects = _staticObjectsHash.getObjects(x, y);
         if (sectorObjects != null) {
            if (sectorObjects.natural != null) objects.push(sectorObjects.natural);
            if (sectorObjects.wreckage != null) objects.push(sectorObjects.wreckage);
            if (sectorObjects.cooldown != null) objects.push(sectorObjects.cooldown);
         }
         return objects;
      }
      
      protected function getNaturalObjectAt(x:int, y:int) : IMStaticSpaceObject {
         var sectorObjects:SectorObjects = _staticObjectsHash.getObjects(x, y);
         return sectorObjects != null ? sectorObjects.natural : null;
      }
   }
}


import flash.utils.Dictionary;

import models.map.IMStaticSpaceObject;
import models.map.MMapSpace;


class SectorObjects
{
   public function SectorObjects() {
   }
   
   public var cooldown:IMStaticSpaceObject;
   public var wreckage:IMStaticSpaceObject;
   public var natural:IMStaticSpaceObject;
   
   public function get hasObjects() : Boolean {
      return cooldown != null || wreckage != null || natural != null;
   }
}

class StaticObjectsHash
{
   private const _hash:Dictionary = new Dictionary();
   
   public function StaticObjectsHash() {
   }

   public function put(object:IMStaticSpaceObject) : void {
      var hashCode:String = computeHashCode(
         object.currentLocation.x,
         object.currentLocation.y
      );
      var objects:SectorObjects = _hash[hashCode];
      if (objects == null) {
         objects = new SectorObjects();
         _hash[hashCode] = objects;
      }
      switch (object.objectType) {
         case MMapSpace.STATIC_OBJECT_NATURAL:
            objects.natural = object;
            break;
         case MMapSpace.STATIC_OBJECT_COOLDOWN:
            objects.cooldown = object;
            break;
         case MMapSpace.STATIC_OBJECT_WRECKAGE:
            objects.wreckage = object;
            break;
         default:
            throw new ArgumentError(
               "Unknown object type " + object.objectType + "!"
            );
      }
   }
   
   public function removeObject(object:IMStaticSpaceObject) : void {
      var hashCode:String = computeHashCode(
         object.currentLocation.x,
         object.currentLocation.y
      );

      var objects:SectorObjects = _hash[hashCode];
      switch (object.objectType) {
         case MMapSpace.STATIC_OBJECT_NATURAL:
            objects.natural = null;
            break;
         case MMapSpace.STATIC_OBJECT_COOLDOWN:
            objects.cooldown = null;
            break;
         case MMapSpace.STATIC_OBJECT_WRECKAGE:
            objects.wreckage = null;
            break;
         default:
            throw new ArgumentError(
               "Unknown object type " + object.objectType + "!"
            );
      }
      
      if (!objects.hasObjects) {
         delete _hash[hashCode];
      }
   }
   
   public function getObjects(x:int, y:int) : SectorObjects {
      return _hash[computeHashCode(x, y)];
   }

   private function computeHashCode(x:int, y:int) : String {
      return x + "," + y;
   }
}