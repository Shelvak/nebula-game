package models.map
{
   
   import models.BaseModel;
   
   import mx.collections.ListCollectionView;
   
   import utils.datastructures.Collections;
   
   
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
      
      protected function getWreckageObjectAt(x:int, y:int) : IMStaticSpaceObject {
         var sectorObjects:SectorObjects = _staticObjectsHash.getObjects(x, y);
         return sectorObjects != null ? sectorObjects.wreckage : null;
      }
      
      protected function getCooldownObjectAt(x:int, y:int) : IMStaticSpaceObject {
         var sectorObjects:SectorObjects = _staticObjectsHash.getObjects(x, y);
         return sectorObjects != null ? sectorObjects.cooldown : null;
      }
   }
}


import flash.utils.Dictionary;

import models.map.IMStaticSpaceObject;
import models.map.MMapSpace;

import mx.logging.ILogger;

import mx.logging.Log;

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

   public static function getLogger() : ILogger {
      return Log.getLogger("models.map.MMapSpace");
   }

   public function put(object:IMStaticSpaceObject) : void {
      var hashCode:String = computeHashCode(
         object.currentLocation.x,
         object.currentLocation.y
      );
      getLogger().debug("Putting " + object.toString() +
        " to StaticObjectsHash (hashcode: " + hashCode + ").");

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
            throw new ArgumentError("Unknown object type " + object.objectType
               + "!")
      }
   }
   
   public function removeObject(object:IMStaticSpaceObject) : void {
      var hashCode:String = computeHashCode(
         object.currentLocation.x,
         object.currentLocation.y
      );
      getLogger().debug("Removing " + object.toString() +
        " from StaticObjectsHash (hashcode: " + hashCode + ").");

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
            throw new ArgumentError("Unknown object type " + object.objectType
               + "!")
      }
      
      if (!objects.hasObjects) {
         getLogger().debug("No objects found for hashcode: " + hashCode +
            ", deleting from hash.");
         delete _hash[hashCode];
      }
   }
   
   public function getObjects(x:int, y:int) : SectorObjects {
      return _hash[computeHashCode(x, y)];
   }
   
   public function hasObjects(x:int, y:int) : Boolean {
      return _hash[computeHashCode(x, y)] != null;
   }
   
   private function computeHashCode(x:int, y:int) : String {
      return x + "," + y;
   }
}