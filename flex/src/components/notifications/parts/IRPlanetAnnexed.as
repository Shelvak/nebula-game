package components.notifications.parts
{
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.PlanetAnnexedSkin;
   
   import controllers.GlobalFlags;
   import controllers.players.PlayersCommand;
   import controllers.ui.NavigationController;
   
   import flash.events.MouseEvent;
   
   import models.notification.parts.PlanetAnnexed;
   
   import spark.components.Label;
   
   import utils.locale.Localizer;
   
   
   public class IRPlanetAnnexed extends IRNotificationPartBase
   {
      public function IRPlanetAnnexed()
      {
         super();
         setStyle("skinClass", PlanetAnnexedSkin);
      };
      
      
      [SkinPart(required="true")]
      public var location:MiniLocationComp;
      
      [SkinPart(required="true")]
      public var lblConquere:Label;
      
      [SkinPart(required="true")]
      public var lblRelatedPlayer: Label;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         function addLinkListeners(): void
         {
            lblRelatedPlayer.addEventListener(MouseEvent.ROLL_OVER, function(e: MouseEvent): void
            {
               lblRelatedPlayer.setStyle('color', 0xffffff);
            });
            lblRelatedPlayer.addEventListener(MouseEvent.ROLL_OUT, function(e: MouseEvent): void
            {
               lblRelatedPlayer.setStyle('color', 0xff0000);
            });
            lblRelatedPlayer.addEventListener(MouseEvent.CLICK, function(e: MouseEvent): void
            {
               GlobalFlags.getInstance().lockApplication = true;
               new PlayersCommand(PlayersCommand.RATINGS, part.oldPlayer?part.oldPlayer.name:
                  part.newPlayer.name).dispatch();
            });
         }
         if (f_NotificationPartChange)
         {
            var part: PlanetAnnexed = PlanetAnnexed(notificationPart);
            location.location = part.location;
            if (part.won)
            {
               if (part.oldPlayer)
               {
                  lblConquere.text = Localizer.string('Notifications', 'label.oldPlayer');
                  lblRelatedPlayer.text = part.oldPlayer.name;
                  addLinkListeners();
               }
               else
               {
                  lblConquere.text = Localizer.string('Notifications', 'label.noPlayer');
               }
            }
            else
            {
               if (part.newPlayer)
               {
                  lblConquere.text = Localizer.string('Notifications', 'label.newPlayer');
                  lblRelatedPlayer.text = part.newPlayer.name;
                  addLinkListeners();
               }
               else
               {
                  lblConquere.text = Localizer.string('Notifications', 'label.npcAnexed');
               }
            }
         }
         f_NotificationPartChange = false;
      }
   }
}