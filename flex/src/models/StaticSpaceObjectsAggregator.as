package models
{
   import flash.errors.IllegalOperationError;
   
   import models.location.LocationMinimal;
   
   import mx.collections.ArrayCollection;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Aggregates different static space objects in the same location. At least one static space object must
    * be added to this list. Can only hold one instance of specific <code>IStaticSpaceObject</code> type
    * (<code>TYPE_NATURAL</code> and <code>TYPE_WRECKAGE</code> constants)
    */
   public class StaticSpaceObjectsAggregator extends ArrayCollection
   {
      public static const TYPE_NATURAL:String = "naturalSpaceObject";
      public static const TYPE_WRECKAGE:String = "wreckage";
      
      
      public function StaticSpaceObjectsAggregator(source:Array = null)
      {
         super(source);
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
         return IStaticSpaceSectorObject(getItemAt(0)).currentLocation;
      }
      
      
      public override function addItemAt(item:Object, index:int) : void
      {
         var newObject:IStaticSpaceSectorObject = IStaticSpaceSectorObject(item);
         if (length != 0 && !newObject.currentLocation.equals(currentLocation))
         {
            throw new IllegalOperationError("Can't add given object " + item + " to this list: other objects " +
                                            "are not in the same location (" + currentLocation + ")");
         }
         var objectOfSameType:IStaticSpaceSectorObject = Collections.findFirst(this,
            function(object:IStaticSpaceSectorObject) : Boolean
            {
               return object.objectType == newObject.objectType;
            }
         );
         if (objectOfSameType)
         {
            throw new IllegalOperationError("New object " + newObject + " is of the same objectType as " +
                                            "another object " + objectOfSameType + "in this list");
         }
         super.addItemAt(item, index);
      }
   }
}