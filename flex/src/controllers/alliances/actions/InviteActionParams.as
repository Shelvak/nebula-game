package controllers.alliances.actions
{
   /**
    * Aggregates parameters of <code>controllers.alliance.actions.InviteAction</code> client command.
    * 
    * @see #InviteActionParams()
    * @see #planetId
    * @see InviteAction
    */
   public class InviteActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #planetId
       */
      public function InviteActionParams(planetId:int)
      {
         super();
         this.planetId = planetId;
      }
      
      
      /**
       * ID of a visible planet player wants to invite its owner of. <b>Required.</b>
       */
      public var planetId:int;
   }
}