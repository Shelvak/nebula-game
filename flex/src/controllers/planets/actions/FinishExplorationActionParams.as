package controllers.planets.actions
{
   import utils.Objects;

   /**
    * Aggregates parameters of <code>controllers.planets.actions.FinishExplorationAction</code> client command.
    * 
    * @see #FinishExplorationActionParams()
    * @see #id
    */
   public class FinishExplorationActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #id
       */
      public function FinishExplorationActionParams(id:int) {
         if (id <= 0)
            throw new ArgumentError("[param id] must be greater than 0 but was " + id);
         this.id = id;
      }
      
      /**
       * Id of the planet to instantly finish exploration in.
       * <p><b>Required. Greater than 0.</b></p>
       */
      public var id:int;
   }
}