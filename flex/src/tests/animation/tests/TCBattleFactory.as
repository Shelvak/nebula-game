package tests.animation.tests
{
   import flash.geom.Point;
   
   import models.battle.BPlayers;
   import models.battle.BattleMatrix;
   
   import org.flexunit.asserts.assertEquals;
   import org.hamcrest.assertThat;
   
   
   public class TCBattleFactory
   {
      
      private var napRules: Object = {12: [13, 14], 13: [12, 14], 14: [12, 13]};
      private var ally1: Array = [{'id':1, 'name': 'orc'}, {'id':2, 'name': 'arc'}, {'id':3, 'name': 'vrc'}];
      private var ally2: Array = [{'id':4, 'name': 'onc'}, {'id':5, 'name': 'auio'}, {'id':6, 'name': 'dfg'}];
      private var ally3: Array = [{'id':7, 'name': 'swfgh'}, {'id':8, 'name': 'vghk'}, {'id':9, 'name': 'gho'}];
      private var ally4: Array = [{'id':10, 'name': 'zrv'}, {'id':11, 'name': 'scg'}, {'id':12, 'name': 'xcg'}];
      private var players: BPlayers = new BPlayers();
      
      [Before]
      public function setUp():void
      {
         players.clear();
        players.napRules = napRules;
        players.addAlliance(ally1, '12');
        players.addAlliance(ally2, '13');
        players.addAlliance(ally3, '14');
        players.addAlliance(ally4, '15');
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