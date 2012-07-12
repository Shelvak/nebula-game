package controllers.galaxies.actions
{
   import components.map.space.galaxy.entiregalaxy.MEntireGalaxyScreen;
   import components.map.space.galaxy.entiregalaxy.MiniSS;
   import components.map.space.galaxy.entiregalaxy.MiniSSType;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.galaxy.MEntireGalaxy;

   import utils.ObjectPropertyType;

   import utils.Objects;


   public class MapAction extends CommunicationAction
   {
      override public function applyServerAction(cmd: CommunicationCommand): void {
         const params: Object = cmd.parameters;
         const playerHomeSS: MiniSS =
            new MiniSS(params[MiniSSType.PLAYER_HOME], MiniSSType.PLAYER_HOME);
         params[MiniSSType.PLAYER_HOME] = new Array(params[MiniSSType.PLAYER_HOME]);

         const solarSystems: Array = new Array();
         Objects.forEachStaticValue(
            MiniSSType, ObjectPropertyType.STATIC_CONST,
            function (ssType: String): void {
               for each (var coords: Array in params[ssType]) {
                  solarSystems.push(new MiniSS(coords, ssType));
               }
            });

         const screen: MEntireGalaxyScreen = MEntireGalaxyScreen.getInstance();
         screen.model = new MEntireGalaxy(ML.latestGalaxy.fowEntries, solarSystems, playerHomeSS);
         screen.show();
      }
   }
}
