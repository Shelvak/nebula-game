package tests.animation
{
   import flash.geom.Point;
   
   import models.battle.BPlayers;
   import models.battle.BattleMatrix;
   
   import org.flexunit.asserts.assertEquals;
   import org.hamcrest.assertThat;
   
   
   public class TC_BattleFactory
   {
      
      private var napRules: Object = {12: [13, 14], 13: [12, 14], 14: [12, 13]};
      private var ally1: Array = [[1, 'orc'], [2, 'arc'], [3, 'vrc']];
      private var ally2: Array = [[4, 'onc'], [5, 'auio'], [6, 'dfg']];
      private var ally3: Array = [[7, 'swfgh'], [8, 'vghk'], [9, 'gho']];
      private var ally4: Array = [[10, 'zrv'], [11, 'scg'], [12, 'xcg']];
      private var players: BPlayers = new BPlayers();
      
      [Before]
      public function setUp():void
      {
         players.clear();
        players.napRules = napRules;
        players.addAlliance(ally1, '12', "alliance1", 2);
        players.addAlliance(ally2, '13', "alliance1", 2);
        players.addAlliance(ally3, '14', "alliance1", 2);
        players.addAlliance(ally4, '15', "alliance1", 2);
      }
      
      [Test]
      public function playerStatusTest (): void
      {
         assertEquals("Should find if it's current player", 0,
            players.getPlayerStatus(2, 2));
         
         assertEquals("Should find if it's my alliance player", 1,
            players.getPlayerStatus(2, 3));
         
         assertEquals("Should find if it's my nap player", 2,
            players.getPlayerStatus(2, 5));
         
         assertEquals("Should find if it's my enemy player", 3,
            players.getPlayerStatus(2, 11));
      }
      
      
      [After]
      public function tearDown():void
      {
      }
   }
}