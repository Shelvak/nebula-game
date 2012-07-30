package components.ratings
{
   import flashx.textLayout.formats.TextAlign;

   import models.ModelLocator;
   import models.galaxy.Galaxy;
   import models.player.MRatingPlayer;

   import spark.components.Label;

   import utils.DateUtil;
   import utils.locale.Localizer;


   public class DeathOrVPLabel extends Label
   {
      public function DeathOrVPLabel() {
         super();
         width = RatingsWidths.victoryPoints;
         setStyle("textAlign", TextAlign.CENTER);
      }

      public function set player(value: MRatingPlayer): void {
         const galaxy: Galaxy = ModelLocator.getInstance().latestGalaxy;
         const player: MRatingPlayer = value;

         toolTip = "";
         text = "";

         if (galaxy == null || player == null) {
            return;
         }

         if (galaxy.apocalypseHasStarted) {
            text = player.deathDayLabel;
            toolTip = player.deathDayTooltip;
         }
         else {
            text = player.victoryPoints.toString();
         }
      }
   }
}
