package controllers.units.actions
{
   import models.location.LocationMinimal;
   
   import utils.Objects;
   
   
   /**
    * Aggregates parameters of <code>controllers.units.actions.ArrivalDateAction</code> client command.
    * 
    * @see #ArrivalDateActionParams()
    * @see #unitIds
    * @see #sourceLocation
    * @see #targetLocation
    * @see #avoidNpc
    */
   public class ArrivalDateActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #unitIds
       * @see #sourceLocation
       * @see #targetLocation
       * @see #avoidNpc
       */
      public function ArrivalDateActionParams(unitIds:Vector.<int>,
                                              sourceLocation:LocationMinimal,
                                              targetLocation:LocationMinimal,
                                              avoidNpc:Boolean)
      {
         Objects.paramNotNull("unitIds", unitIds);
         if (unitIds.length == 0)
         {
            throw new ArgumentError("[param unitIds] must contain at least one item");
         }
         Objects.paramNotNull("sourceLocation", sourceLocation);
         Objects.paramNotNull("targetLocation", targetLocation);
         if (sourceLocation.equals(targetLocation))
         {
            throw new ArgumentError(
               "[param sourceLocation] and [param targetLocation] must not define the same location: " +
               sourceLocation
            );
         }
         
         this.unitIds = unitIds;
         this.sourceLocation = sourceLocation;
         this.targetLocation = targetLocation;
         this.avoidNpc = avoidNpc;
      }
      
      
      /**
       * List of unit IDs that will be moved.
       * <b>Required. Not null. Must contain at least one item.</b>
       */
      public var unitIds:Vector.<int>;
      
      
      /**
       * Current location of units to be moved.
       * <b>Required. Not null. Must be different from <code>targetLocation</code>.</b>
       */
      public var sourceLocation:LocationMinimal;
      
      
      /**
       * Destination of units.
       * <b>Required. Not null. Must be different from <code>sourceLocation</code>.</b>
       */
      public var targetLocation:LocationMinimal;
      
      
      /**
       * Should the squad avoid NPC units when flying.
       * <b>Required.</b>
       */
      public var avoidNpc:Boolean;
   }
}