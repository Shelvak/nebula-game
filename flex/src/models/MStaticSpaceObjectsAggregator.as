package models
{
   import flash.errors.IllegalOperationError;
   
   import models.location.LocationMinimal;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.utils.ObjectUtil;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Aggregates different static space objects in the same location. At least one static space object must
    * be added to this list. Can only hold one instance of specific <code>IStaticSpaceObject</code> type
    * (<code>TYPE_NATURAL</code> and <code>TYPE_WRECKAGE</code> constants)
    */
   public class MStaticSpaceObjectsAggregator extends ArrayCollection
   {
      public function MStaticSpaceObjectsAggregator(source:Array = null)
      {
         super(source);
         sort = new Sort();
         sort.compareFunction = function(objectA:IMStaticSpaceObject,
                                         objectB:IMStaticSpaceObject,
                                         fields:Array = null) : int
         {
            return ObjectUtil.numericCompare(objectA.objectType, objectB.objectType);
         }
         refresh();
      }
      
      
      /**
       * @see IStaticSpaceSectorObject#height
       */
      public function get componentWidth() : int
      {
         var w:int = 0;
         for each (var object:IMStaticSpaceObject in this)
         {
            w = Math.max(w, object.componentWidth);
         }
         return w;
      }
      
      
      /**
       * @see IStaticSpaceSectorObject#height
       */
      public function get componentHeight() : int
      {
         var h:int = 0;
         for each (var object:IMStaticSpaceObject in this)
         {
            h = Math.max(h, object.componentHeight);
         }
         return h;
      }
      
      
      public function get isNavigable() : Boolean
      {
         return getNavigableObject() != null;
      }
      
      
      public function navigateTo() : void
      {
         var object:IMStaticSpaceObject = getNavigableObject();
         if (object)
         {
            object.navigateTo();
         }
         else
         {
            throw new IllegalOperationError("No navigable objects in this aggregator " + this);
         }
      }
      
      
      /**
       * Looks for an object of given type (see <code>TYPE_*</code> constants).
       */
      public function findObjectOfType(type:int) : IMStaticSpaceObject
      {
         return Collections.findFirst(this,
            function(object:IMStaticSpaceObject) : Boolean
            {
               return object.objectType == type;
            }
         );
      }
      
      
      /**
       * Location all agregated space objects are in.
       */
      public function get currentLocation() : LocationMinimal
      {
         if (length == 0)
         {
            throw new IllegalOperationError("There are no static objects aggregated by this StaticSpaceSectorObject");
         }
         return IMStaticSpaceObject(getItemAt(0)).currentLocation;
      }
      
      
      public override function addItemAt(item:Object, index:int) : void
      {
         var newObject:IMStaticSpaceObject = IMStaticSpaceObject(item);
         if (length != 0 && !newObject.currentLocation.equals(currentLocation))
         {
            throw new IllegalOperationError("Can't add given object " + item + " to this list: other objects " +
                                            "are not in the same location (" + currentLocation + ")");
         }
         var objectOfSameType:IMStaticSpaceObject = findObjectOfType(newObject.objectType);
         if (objectOfSameType)
         {
            throw new IllegalOperationError("New object " + newObject + " is of the same objectType as " +
                                            "another object " + objectOfSameType + "in this list");
         }
         super.addItemAt(item, index);
      }
      
      
      private function getNavigableObject() : IMStaticSpaceObject
      {
         return Collections.findFirst(this,
            function(object:IMStaticSpaceObject) : Boolean
            {
               return object.isNavigable;
            }
         );
      }
   }
}