package components.notifications.parts
{
import components.alliance.AllianceScreenM;
import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.AllianceInvitationSkin;

   import flash.events.Event;
   import flash.events.MouseEvent;

import globalevents.GlobalEvent;

import models.ModelLocator;
import models.alliance.events.MAllianceEvent;
import models.notification.parts.AllianceInvitation;
   import models.player.events.PlayerEvent;
   
   import spark.components.Button;
   import spark.components.Label;
import spark.components.RichEditableText;

import utils.TextFlowUtil;

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
          ML.player.removeEventListener(PlayerEvent.ALLIANCE_ID_CHANGE, player_allianceChangeHandler, false);
          ML.player.removeEventListener(PlayerEvent.ALLIANCE_COOLDOWN_CHANGE, player_allianceChangeHandler, false);
      }      
      
      private function this_addedToStageHandler(event:Event) : void {
          ML.player.addEventListener(PlayerEvent.ALLIANCE_ID_CHANGE, player_allianceChangeHandler, false, 0, true);
          ML.player.addEventListener(PlayerEvent.ALLIANCE_COOLDOWN_CHANGE, player_allianceChangeHandler, false, 0, true);
      }
      
      private function player_allianceChangeHandler(event:PlayerEvent) : void {
         updateJoinButtonAndMessage();
      }

      private function updateRestrictionMessage(e: GlobalEvent = null): void
      {
          if (ML.player != null && !ML.player.canJoinAlliance)
          {
              joinRestrictionMessage.text = model.joinRestrictionMessage;
          }
          else
          {
              if (message.textFlow != null)
              {
                  message.textFlow.removeEventListener("openAlliance", openAlliance);
              }
              message.textFlow = TextFlowUtil.importFromString(model.innerMessage);
              message.textFlow.addEventListener("openAlliance", openAlliance);
              joinRestrictionMessage.visible = joinRestrictionMessage.includeInLayout = false;
              joinButton.visible = joinButton.includeInLayout = true;
              GlobalEvent.unsubscribe_TIMED_UPDATE(updateRestrictionMessage);
          }
      }
      
      private function updateJoinButtonAndMessage() : void {
         if (joinRestrictionMessage != null && joinButton != null && model != null) {
             if (message.textFlow != null)
             {
                 message.textFlow.removeEventListener("openAlliance", openAlliance);
             }
             message.textFlow = TextFlowUtil.importFromString(model.innerMessage);
             message.textFlow.addEventListener("openAlliance", openAlliance);
            joinButton.visible = joinButton.includeInLayout = ML.player.canJoinAlliance;
            joinRestrictionMessage.visible = joinRestrictionMessage.includeInLayout = !ML.player.canJoinAlliance;
            if (!ML.player.canJoinAlliance)
            {
                joinRestrictionMessage.text = model.joinRestrictionMessage;
                if (!ML.player.belongsToAlliance)
                {
                    GlobalEvent.subscribe_TIMED_UPDATE(updateRestrictionMessage);
                }
            }
         }
      }
      
      [SkinPart(required="true")]
      public var message:RichEditableText;
      
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
       
      private function openAlliance(e: Event): void
      {
          AllianceScreenM.getInstance().showScreen(model.allianceId);
      }
      
      override protected function commitProperties() : void {
         super.commitProperties();
         if (f_NotificationPartChange) {
            updateJoinButtonAndMessage();
         }
         f_NotificationPartChange = false;
      }
      
      private function getString(property:String, parameters:Array = null) : String {
         return Localizer.string("Notifications", property, parameters);
      }
   }
}