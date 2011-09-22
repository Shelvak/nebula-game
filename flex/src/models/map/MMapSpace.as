package models.map
{
   import models.IMStaticSpaceObject;
   
   import mx.collections.ListCollectionView;
   
   import utils.datastructures.Collections;
   
   
   public class MMapSpace extends MMap
   {
      public static const STATIC_OBJECT_COOLDOWN:int = 0;
      public static const STATIC_OBJECT_NATURAL:int  = 1;
      public static const STATIC_OBJECT_WRECKAGE:int = 2;
      
      
      public function MMapSpace()
      {
         super();
         _naturalObjects = Collections.filter(objects, ff_naturalObjects);
         _wreckages = Collections.filter(objects, ff_wreckages);
         _cooldowns = Collections.filter(objects, ff_cooldowns);
      }
      
      
      private var _wreckages:ListCollectionView;
      private function ff_wreckages(object:IMStaticSpaceObject) : Boolean
      {
         return object.objectType == STATIC_OBJECT_WRECKAGE;
      }
      [Bindable(event="willNotChange")]
      /**
       * List of all wreckages on this map (bound to <code>objects</code> collection).
       */
      public function get wreckages() : ListCollectionView
      {
         return _wreckages;
      }
      
      
      private var _naturalObjects:ListCollectionView;
      private function ff_naturalObjects(object:IMStaticSpaceObject) : Boolean
      {
         return object.objectType == STATIC_OBJECT_NATURAL;
      }
      [Bindable(event="willNotChange")]
      /**
       * List of all naturalObjects on this map (bound to <code>objects</code> collection).
       */
      public function get naturalObjects() : ListCollectionView
      {
         return _naturalObjects;
      }
      
      
      private var _cooldowns:ListCollectionView;
      private function ff_cooldowns(object:IMStaticSpaceObject) : Boolean
      {
         return object.objectType == STATIC_OBJECT_COOLDOWN;
      }
      [Bindable(event="willNotChange")]
      /**
       * List of all cooldowns on this map (bound to <code>objects</code> collection).
       */
      public function get cooldowns() : ListCollectionView
      {
         return _cooldowns;
      }
   }
}