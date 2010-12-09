package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Starts exploration of a planet.
    * 
    * <p>
    * Client -->> Server
    * <ul>
    *    <li><code>planet</code> - a planet in wich to explore</li>
    *    <li><code>folliage</code> - a folliage to explore</li>
    * </ul>
    * </p>
    */
   public class ExploreAction extends CommunicationAction
   {
      public function ExploreAction()
      {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var params:Object = cmd.parameters;
         sendMessage(new ClientRMO({
            "planetId": params.planet.id,
            "x": params.folliage.x,
            "y": params.folliage.y
         }, params.folliage));
      }
   }
}