package models.notification.parts
{
   import controllers.alliances.AlliancesCommand;
   import controllers.ui.NavigationController;

   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.FlowElementMouseEvent;

   import models.ModelLocator;
   import models.alliance.MAllianceMinimal;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.player.PlayerMinimal;

   import utils.Objects;
   import utils.StringUtil;
   import utils.TextFlowUtil;
   import utils.locale.Localizer;


   public class AllianceOwnerChanged implements INotificationPart
   {
      private var _alliance:MAllianceMinimal;
      private var _newOwner:PlayerMinimal;
      private var _oldOwner:PlayerMinimal;

      private function get player(): PlayerMinimal {
         return ModelLocator.getInstance().player;
      }

      public function AllianceOwnerChanged(notification:Notification) {
         const params:Object = notification.params;
         _alliance = Objects.create(MAllianceMinimal, params["alliance"]);
         _newOwner = Objects.create(PlayerMinimal, params["newOwner"]);
         _oldOwner = Objects.create(PlayerMinimal, params["oldOwner"]);

         const propPrefix:String = "content.allianceOwnerChanged.";
         const allianceName: String = StringUtil.escapeXML(_alliance.name);
         const newOwnerName: String = StringUtil.escapeXML(_newOwner.name);
         const oldOwnerName: String = StringUtil.escapeXML(_oldOwner.name);
         var contentString:String;
         if (player.equals(_oldOwner)) {
            contentString = getString(
               propPrefix + "forOldOwner", [allianceName, newOwnerName]
            )
         }
         else if (player.equals(_newOwner)) {
            contentString = getString(
               propPrefix + "forNewOwner", [allianceName, oldOwnerName]
            );
         }
         else {
            contentString = getString(
               propPrefix + "forOthers",
               [allianceName, oldOwnerName, newOwnerName]
            );
         }
         _content = TextFlowUtil.importFromString(contentString);
      }

      public function get title(): String {
         return getString("title.allianceOwnerChanged", [_alliance.name]);
      }

      public function get message(): String {
         return title;
      }

      private var _content:TextFlow;
      public function getContent(): TextFlow {
         var clone:TextFlow = _content.deepCopy().getTextFlow();
         addLinkClickListener(clone, "alliance", allianceLink_clickHandler);
         addLinkClickListener(clone, "newOwner", newOwnerLink_clickHandler);
         addLinkClickListener(clone, "oldOwner", oldOwnerLink_clickHandler);
         return clone;
      }

      private function addLinkClickListener(target:TextFlow,
                                            eventType:String,
                                            handler:Function): void {
         target.addEventListener(eventType, handler, false, 0, true);
      }

      private function allianceLink_clickHandler(event:FlowElementMouseEvent): void {
         new AlliancesCommand(
            AlliancesCommand.SHOW, {"id": _alliance.id}
         ).dispatch();
         NavigationController.getInstance().showAllianceScreen();
      }

      private function newOwnerLink_clickHandler(event:FlowElementMouseEvent): void {
         _newOwner.show();
      }

      private function oldOwnerLink_clickHandler(event:FlowElementMouseEvent): void {
         _oldOwner.show();
      }

      private function getString(property:String, parameters:Array = null): String {
         return Localizer.string("Notifications", property, parameters);
      }

      /**
       * No-op.
       */
      public function updateLocationName(id: int, name: String): void {}
   }
}
