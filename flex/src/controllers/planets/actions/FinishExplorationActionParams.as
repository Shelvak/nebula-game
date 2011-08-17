package controllers.planets.actions
{
   import utils.Objects;

   /**
    * Aggregates parameters of <code>controllers.planets.actions.FinishExplorationAction</code> client command.
    * 
    * @see #FinishExplorationActionParams()
    * @see #planetId
    */
   public class FinishExplorationActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #planetId
       */
      public function FinishExplorationActionParams(planetId:int) {
         if (planetId <= 0)
            throw new ArgumentError("[param planetId] must be greater than 0 but was " + planetId);
         this.planetId = planetId;
      }
      
      /**
       * Id of the planet to instantly finish exploration in.
       * <p><b>Required. Greater than 0.</b></p>
       */
      public var planetId:int;
   }
}