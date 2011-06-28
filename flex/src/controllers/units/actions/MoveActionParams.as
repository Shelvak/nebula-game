package controllers.units.actions
{
   import models.location.LocationMinimal;
   import models.movement.MSquadron;
   
   
   /**
    * Aggregates parameters of <code>controllers.units.actions.MoveAction</code> client command.
    * 
    * @see #MoveActionParams()
    * @see #unitIds
    * @see #sourceLocation
    * @see #targetLocation
    * @see #avoidNpc
    * @see #speedModifier
    * @see #squadron
    */
   public class MoveActionParams extends MoveMetaActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #unitIds
       * @see #sourceLocation
       * @see #targetLocation
       * @see #avoidNpc
       * @see #speedModifier
       * @see #squadron
       */
      public function MoveActionParams(unitIds:Array,
                                       sourceLocation:LocationMinimal,
                                       targetLocation:LocationMinimal,
                                       avoidNpc:Boolean,
                                       speedModifier:Number,
                                       squadron:MSquadron)
      {
         super(unitIds, sourceLocation, targetLocation, avoidNpc);
         this.speedModifier = speedModifier;
      }
      
      
      /**
       * If this is less than 1, units will move faster than default speed and player will have to
       * pay for this with credits. <b>Required.</b>
       */
      public var speedModifier:Number;
      
      
      /**
       * Squadron that units with give IDs are. <b>Optional.</b> 
       */
      public var squadron:MSquadron;
   }
}