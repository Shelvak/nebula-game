package models.map
{
   import models.IMStaticSpaceObject;
   
   import mx.collections.ListCollectionView;
   
   import utils.datastructures.Collections;
   
   
   public class MMapSpace extends MMap
   {
      public static const STATIC_OBJECT_NATURAL:int  = 0;
      public static const STATIC_OBJECT_WRECKAGE:int = 1;
      
      
      public function MMapSpace()
      {
         super();
         _naturalObjects = Collections.filter(objects, filterFunction_naturalObjects);
         _wreckages = Collections.filter(objects, filterFunction_wreckages);
      }
      
      
      private var _wreckages:ListCollectionView;
      private function filterFunction_wreckages(object:IMStaticSpaceObject) : Boolean
      {
         return object.objectType == STATIC_OBJECT_NATURAL;
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
      private function filterFunction_naturalObjects(object:IMStaticSpaceObject) : Boolean
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
   }
}