package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.AllianceInvitationSkin;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import models.ModelLocator;
   import models.notification.parts.AllianceInvitation;
   import models.player.events.PlayerEvent;
   
   import spark.components.Button;
   import spark.components.Label;
   
   import utils.locale.Localizer;
   
   
   public class IRAllianceInvitation extends IRNotificationPartBase
   {
      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function IRAllianceInvitation() {
         super();
         setStyle("skinClass", AllianceInvitationSkin);
         addEventListener(Event.ADDED_TO_STAGE, this_addedToStageHandler);
         addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
      }
      
      private function get model() : AllianceInvitation {
         return AllianceInvitation(notificationPart);
      }
      
      private function this_removedFromStageHandler(event:Event) : void {
         ML.player.addEventListener(PlayerEvent.ALLIANCE_ID_CHANGE, player_allianceChangeHandler, false, 0, true);
         ML.player.addEventListener(PlayerEvent.ALLIANCE_COOLDOWN_CHANGE, player_allianceChangeHandler, false, 0, true);
      }      
      
      private function this_addedToStageHandler(event:Event) : void {
         ML.player.removeEventListener(PlayerEvent.ALLIANCE_ID_CHANGE, player_allianceChangeHandler, false);
         ML.player.removeEventListener(PlayerEvent.ALLIANCE_COOLDOWN_CHANGE, player_allianceChangeHandler, false);
      }
      
      private function player_allianceChangeHandler(event:PlayerEvent) : void {
         updateJoinButtonAndRestrictionMessage();
      }
      
      private function updateJoinButtonAndRestrictionMessage() : void {
         if (joinRestrictionMessage != null && joinButton != null && model != null) {
            joinButton.visible = joinButton.includeInLayout = ML.player.canJoinAlliance;
            joinRestrictionMessage.visible = joinRestrictionMessage.includeInLayout = !ML.player.canJoinAlliance;
            if (!ML.player.canJoinAlliance)
               joinRestrictionMessage.text = model.joinRestrictionMessage;
         }
      }
      
      [SkinPart(required="true")]
      public var message:Label;
      
      [SkinPart(required="true")]
      public var joinRestrictionMessage:Label;
      
      [SkinPart(required="true")]
      public var joinButton:Button;
      
      override protected function partAdded(partName:String, instance:Object) : void {
         switch (instance) {
            case joinButton:
               joinButton.addEventListener(MouseEvent.CLICK, joinButton_clickHandler, false, 0, true);
               joinButton.label = getString("label.allianceInvitation.join");
               break;
         }
      }
      
      private function joinButton_clickHandler(event:MouseEvent) : void {
         AllianceInvitation(notificationPart).joinAlliance();
      }
      
      override protected function commitProperties() : void {
         super.commitProperties();
         if (f_NotificationPartChange) {
            message.text = model.message;
            updateJoinButtonAndRestrictionMessage();
         }
         f_NotificationPartChange = false;
      }
      
      private function getString(property:String, parameters:Array = null) : String {
         return Localizer.string("Notifications", property, parameters);
      }
   }
}