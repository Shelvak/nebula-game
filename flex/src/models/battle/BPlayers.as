package models.battle
{
   import mx.collections.ArrayCollection;
   
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
      
      public function addAlliance(alliance: Array, id: String): void
      {
         var allianceArray: Array = new Array();
         for each (var player: Object in alliance)
         allianceArray.push(player.id);
         
         alliances[id] = allianceArray;
      }
      
      public function getAlliance(allianceId: String): Array
      {
         return alliances[allianceId];
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