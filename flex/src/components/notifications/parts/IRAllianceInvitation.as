package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.AllianceInvitationSkin;
   
   import controllers.alliances.AlliancesCommand;
   import controllers.alliances.actions.JoinActionParams;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import globalevents.GlobalEvent;
   
   import models.notification.parts.AllianceInvitation;
   
   import spark.components.Button;
   import spark.components.Label;
   
   import utils.locale.Localizer;
   
   
   public class IRAllianceInvitation extends IRNotificationPartBase
   {
      public function IRAllianceInvitation()
      {
         super();
         setStyle("skinClass", AllianceInvitationSkin);
         addEventListener(Event.ADDED_TO_STAGE, this_addedToStageHandler);
         addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
      }
      
      
      private function get model() : AllianceInvitation
      {
         return AllianceInvitation(notificationPart);
      }
      
      
      private function this_removedFromStageHandler(event:Event) : void
      {
         
         GlobalEvent.subscribe_TIMED_UPDATE(global_timedUpdateHandler);
      }      
      
      
      private function this_addedToStageHandler(event:Event) : void
      {
         GlobalEvent.unsubscribe_TIMED_UPDATE(global_timedUpdateHandler);
      }
      
      
      private function global_timedUpdateHandler(event:GlobalEvent) : void
      {
         if (joinRestrictionMessage != null && joinButton != null && model != null)
         {
            joinButton.visible =
            joinButton.includeInLayout = model.canJoinAlliance;
            joinRestrictionMessage.visible =
            joinRestrictionMessage.includeInLayout = !model.canJoinAlliance;
            if (model.canJoinAlliance)
            {
               joinRestrictionMessage.text = model.joinRestrictionMessage;
            }
         }
      }
      
      
      [SkinPart(required="true")]
      public var message:Label;
      
      
      [SkinPart(required="true")]
      public var joinRestrictionMessage:Label;
      
      
      [SkinPart(required="true")]
      public var joinButton:Button;
      
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         switch (instance)
         {
            case joinButton:
               joinButton.addEventListener(MouseEvent.CLICK, joinButton_clickHandler, false, 0, true);
               joinButton.label = getString("label.allianceInvitation.join");
               break;
         }
      }
      
      
      private function joinButton_clickHandler(event:MouseEvent) : void
      {
         AllianceInvitation(notificationPart).joinAlliance();
      }
      
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            message.text = model.message;
         }
      }
      
      
      private function getString(property:String, parameters:Array = null) : String
      {
         return Localizer.string("Notifications", property, parameters);
      }
   }
}