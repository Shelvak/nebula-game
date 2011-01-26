package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.planet.Planet;
   
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
   public class EditAction extends CommunicationAction
   {
      public function EditAction()
      {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var params:Planet = Planet(cmd.parameters);
         sendMessage(new ClientRMO({
            "id": params.id,
            "name": params.ssObject.name
         }, params));
      }
   }
}