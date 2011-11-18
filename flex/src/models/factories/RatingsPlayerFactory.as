package models.factories
{
   import models.player.MRatingPlayer;

   import mx.collections.ArrayCollection;

   import utils.DateUtil;
   import utils.Objects;


   /**
    * Lets easily create instaces of units. 
    */
   public class RatingsPlayerFactory
   {
      /**
       * Creates a ratings player form a given simple object.
       *  
       * @param data An object representing a ratings player.
       * 
       * @return instance of <code>MRatingPlayer</code> with values of properties
       * loaded from the data object.
       */
      public static function fromObject(data: Object): MRatingPlayer {
         if (!data) {
            throw new Error('Can not create ratings player, null given');
         }
         var player: MRatingPlayer = Objects.create(MRatingPlayer, data);
         player.points = player.warPoints +
                            player.sciencePoints +
                            player.armyPoints +
                            player.economyPoints;
         if (data.lastSeen != null) {
            if (data.lastSeen is String) {
               player.offlineSince = DateUtil.parseServerDTF(data.lastSeen);
            }
            else if (data.lastSeen) {
               player.online = true;
            }
         }
         return player;
      }

      public static function fromObjects(players: Array): ArrayCollection {
         var source: Array = [];
         for each (var playerData: Object in players) {
            var player: MRatingPlayer = fromObject(playerData);
            source.push(player);
         }
         return new ArrayCollection(source);
      }


   }
}