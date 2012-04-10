/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 2/8/12
 * Time: 1:16 PM
 * To change this template use File | Settings | File Templates.
 */
package controllers.buildings.actions {
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.ui.NavigationController;

   import models.Owner;

   import models.building.Building;
   import models.building.Npc;

   import models.factories.UnitFactory;
   import models.unit.UnitKind;

   import utils.remote.rmo.ClientRMO;

   public class ShowGarrisonAction extends CommunicationAction {
      
      private var building: Npc;

      /* takes building as parameters*/
      override public function applyClientAction(cmd: CommunicationCommand): void {
         building = Npc(cmd.parameters);
         ML.units.removeGarrisonUnits();
         sendMessage(new ClientRMO({'id': cmd.parameters.id}));
      }

      public override function applyServerAction(cmd: CommunicationCommand): void {
         ML.units.addAll(UnitFactory.fromObjects(cmd.parameters.units, new Object()));
         NavigationController.getInstance().showUnits(building.units,
                        building, null, UnitKind.GROUND, Owner.ENEMY);
      }
   }
}
