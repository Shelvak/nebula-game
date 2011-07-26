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
   
   import spark.components.Button;
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
      public var lblOutcome:Label;
      
      [SkinPart(required="true")]
      public var lblRelatedPlayer: Button;
      
      [SkinPart(required="true")]
      public var lblAfterLink:Label;
      
      [SkinPart(required="true")]
      public var lblClaimPlanet:Label;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            var part: PlanetAnnexed = PlanetAnnexed(notificationPart);
            function addLinkListeners(): void
            {
               lblRelatedPlayer.addEventListener(MouseEvent.CLICK, function(e: MouseEvent): void
               {
                  GlobalFlags.getInstance().lockApplication = true;
                  new PlayersCommand(PlayersCommand.RATINGS, part.owner.name).dispatch();
               });
            }
            lblRelatedPlayer.visible = false;
            lblAfterLink.visible = false;
            lblClaimPlanet.visible = false;
            location.location = part.location;
            lblOutcome.text = part.notifText;
            if (part.won && part.owner != null)
            {
               lblRelatedPlayer.label = part.owner.name;
               lblRelatedPlayer.visible = true;
               lblAfterLink.text = Localizer.string("Notifications", "label.planetAnnexed.win2",
               [part.location.planetName]);
               lblClaimPlanet.text = Localizer.string("Notifications", "label.planetAnnexed.claimPlanet");
               lblClaimPlanet.visible = true;
               lblAfterLink.visible = true;
               addLinkListeners();
            }
         }
         f_NotificationPartChange = false;
      }
   }
}