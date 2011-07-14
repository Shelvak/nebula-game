package controllers.buildings.actions
{
   import models.building.Building;
   
   import utils.Objects;
   
   
   /**
    * Aggregates parameters of <code>controllers.buildings.actions.MoveAction</code> client command.
    */
   public class MoveActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #building
       * @see #newX
       * @see #newY
       */
      public function MoveActionParams(building:Building, newX:int, newY:int)
      {
         this.building = Objects.paramNotNull("building", building);
         this.newX = newX;
         this.newY = newY;
      }
      
      
      /**
       * Building to move. <b>Required. Not null.</b>
       */
      public var building:Building;
      /**
       * New x coordinate. <b>Required</b>.
       */
      public var newX:int;
      /**
       * New y coordinate. <b>Required</b>.
       */
      public var newY:int;
   }
}