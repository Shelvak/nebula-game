package models.player
{
   import components.player.OnlineStatusTooltip;
   
   import models.BaseModel;
   
   import mx.collections.ArrayCollection;
   import mx.controls.ToolTip;
   import mx.events.ToolTipEvent;
   
   import utils.DateUtil;
   import utils.locale.Localizer;
   
   [Bindable]
   /**
    * Player#ratings Hash
    # {
    # "id" => Fixnum (player ID),
    # "name" => String (player name),
    # "victory_points" => Fixnum,
    # "planets_count" => Fixnum,
    # "war_points" => Fixnum,
    # "science_points" => Fixnum,
    # "economy_points" => Fixnum,
    # "army_points" => Fixnum,
    # "alliance" => {"id" => Fixnum, "name" => String} | nil,
    # "online" => Boolean,
    # }
    */
   public class MRatingPlayer extends BaseModel
   {
      
      public static function refreshRanks(list: ArrayCollection): void
      {
         var i: int = 0;
         for each (var player: MRatingPlayer in list)
         {
            i++;
            player.rank = i;
         }  
      }
      
      public function createStatusTooltip(event:ToolTipEvent):void
      {
         var tooltip: OnlineStatusTooltip = new OnlineStatusTooltip();
         if (online)
         {
            tooltip.statusText = Localizer.string('Ratings', 'online');
         }
         else if (offlineSince == null)
         {
            tooltip.statusText = Localizer.string('Ratings', 'offline');
         }
         else
         {
            tooltip.statusText = Localizer.string('Ratings', 'offlineSince',
               [DateUtil.secondsToHumanString(
                  (new Date().time - offlineSince.time) / 1000, 2),
                  DateUtil.formatShortDateTime(offlineSince)]);
         }
         event.toolTip = tooltip;
      }
      /**
       * total points 
       */      
      public var points: int;
      public var rank: int;
      public var nr: int;
      public var allianceOwnerId: int;
      [Optional]
      public var allianceId: int;
      [Required]
      public var name: String;
      [Required]
      public var planetsCount: int;
      [Optional]
      public var playersCount: int;
      [Optional]
      public var victoryPoints: int;
      [Optional]
      public var allianceVps: int;
      [Required]
      public var warPoints: int;
      [Required]
      public var sciencePoints: int;
      [Required]
      public var economyPoints: int;
      [Required]
      public var armyPoints: int;
      [Optional]
      public var alliance: Object;
      
      public var online: Boolean = false;
      
      public var offlineSince: Date;
      
      public function getAllianceName(): String
      {
         if (alliance)
         {
            return alliance.name;
         }
         else
         {
            return null;
         }
      }
   }
}