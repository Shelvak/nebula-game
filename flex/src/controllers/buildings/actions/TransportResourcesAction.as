/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 1/30/12
 * Time: 1:47 PM
 * To change this template use File | Settings | File Templates.
 */
package controllers.buildings.actions {
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.Messenger;
   import controllers.buildings.TransportResourcesErrorType;

   import utils.locale.Localizer;

   /*
 # Transports resources via +Building::ResourceTransporter+ from source planet
 # (where building is standing) to a target planet. Target must be owned by
 # same player.
 #
 # Invocation: by client
 #
 # Parameters:
 # - id (Fixnum): ID of the resource transporter
 # - target_planet_id (Fixnum): ID of the target planet
 # - metal (Fixnum): amount of metal transported
 # - energy (Fixnum): amount of energy transported
 # - zetium (Fixnum): amount of zetium transported
 #
 # Response:
 # If successful: None
 # If something failed:
 # - error (String): one of the
 # "no_transporter" - if target planet didn't have active transporter
 #
 */
   public class TransportResourcesAction extends CommunicationAction {
      public override function applyServerAction(cmd: CommunicationCommand): void {
         if (cmd.parameters.error == TransportResourcesErrorType.NO_TRANSPORTER)
         {
            Messenger.show(Localizer.string('ResourceTransporter',
               'message.noTransporter'), Messenger.MEDIUM);
         }
      }
   }
}
