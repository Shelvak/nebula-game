package models.battle
{
   import mx.collections.ArrayCollection;
   
   import utils.locale.Localizer;
   
   public class BPlayers
   {
      
      public static const CURRENT: int = 0;
      public static const ALLIANCE: int = 1;
      public static const NAP: int = 2;
      public static const ENEMY: int = 3;
      
      private var alliances: Object;
      
      public var napRules: Object;
      
      public function clear(): void
      {
         alliances = new Object();
      }
      
      [Bindable]
      public var names: ArrayCollection = new ArrayCollection();
      
      public function addAlliance(alliance: Array, id: String, name: String, myId: int): void
      {
         var allianceArray: Array = new Array();
         for each (var player: Object in alliance)
         allianceArray.push(player == null?null:player[0]);
         addPlayers(alliance, name, myId);
         alliances[id] = allianceArray;
      }
      
      private function addPlayers(players: Array, name: String, myId: int): void
      {
         var newPlayers: ArrayCollection = new ArrayCollection();
         
         for each (var player: Object in players)
         {
            newPlayers.addItem({'player':player?player[1]:Localizer.string('Players','npc'), 
               'status': player?getPlayerStatus(myId, player[0]):ENEMY});
         }
         for each (var ally: Object in names)
         {
            if (ally.name == name)
            {
               (ally.players as ArrayCollection).addAll(newPlayers);
               return;
            }
         }
         names.addItem({'name': name, 'players': newPlayers});
      }
      
      public function getAlliance(allianceId: String): Array
      {
         return alliances[allianceId].name;
      }
      
      private function belongsToTheSameAlliance(id: int, id2: int): Boolean
      {
         for each (var alliance: Array in alliances)
         if (alliance.indexOf(id) != -1)
         {
            if (alliance.indexOf(id2) != -1)
               return true
            else
               return false;
         }
         return false;
      }
      
      private function isNap(id: int, id2: int): Boolean
      {
         var firstAlly: String = '';
         var secondAlly: String = '';
         
         for (var allyKey: String in alliances)
         {
            var alliance: Array = alliances[allyKey];
            if (alliance.indexOf(id) != -1)
            {
               firstAlly = allyKey;
            }
            if (alliance.indexOf(id2) != -1)
            {
               secondAlly = allyKey;
            }
         }
         if (napRules[int(firstAlly)] == null)
         {
            return false;
         }
         else
         {
            return ((napRules[int(firstAlly)] as Array).indexOf(int(secondAlly)) != -1);
         }
         
      }
      
      public function getPlayerStatus(myId: int, playerId: int): int
      {
         return (playerId == myId)?CURRENT:
            (belongsToTheSameAlliance(playerId, myId)?ALLIANCE:
               (isNap(playerId, myId)?NAP:ENEMY));
      }
   }
}