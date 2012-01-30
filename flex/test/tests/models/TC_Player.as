package tests.models
{
   import models.player.Player;

   import org.flexunit.assertThat;

   import org.flexunit.asserts.fail;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import utils.DateUtil;


   public class TC_Player
   {
      [Before]
      public function setUp(): void {
         DateUtil.now = new Date(1000).time;
      }

      [Test]
      public function allianceCooldownInEffect_allianceCooldownIdIsSet(): void {
         const allianceId:int = 5;
         function newPlayer(cooldownEnded:Boolean): Player {
            const p:Player = new Player();
            p.allianceCooldownId = allianceId;
            p.allianceCooldown.occuresAt = cooldownEnded
                                              ? new Date(500)
                                              : new Date(1500);
            return p;
         }

         var p:Player = newPlayer(false);
         assertThat(
            "cooldown not in effect for another alliance",
            p.allianceCooldownInEffect(allianceId + 1), isFalse()
         );
         assertThat(
            "cooldown not in effect for zero-alliance",
            p.allianceCooldownInEffect(0), isFalse()
         );
         assertThat(
            "cooldown in effect for the same alliance",
            p.allianceCooldownInEffect(allianceId), isTrue()
         );

         p = newPlayer(true);
         assertThat(
            "cooldown not in effect for another alliance",
            p.allianceCooldownInEffect(allianceId + 1), isFalse()
         );
         assertThat(
            "cooldown not in effect for zero-alliance",
            p.allianceCooldownInEffect(), isFalse()
         );
         assertThat(
            "cooldown not in effect for the same alliance",
            p.allianceCooldownInEffect(allianceId), isFalse()
         );
      }

      [Test]
      public function allianceCooldownInEffect_allianceCooldownIdIsZero(): void {
         function newPlayer(cooldownEnded:Boolean): Player {
            const p:Player = new Player();
            p.allianceCooldown.occuresAt = cooldownEnded
                                              ? new Date(500)
                                              : new Date(1500);
            return p;
         }

         var p:Player = newPlayer(false);
         assertThat(
            "cooldown in effect for non-zero alliance",
            p.allianceCooldownInEffect(10), isTrue()
         );
         assertThat(
            "cooldown in effect for zero-alliance",
            p.allianceCooldownInEffect(), isTrue()
         );

         p = newPlayer(true);
         assertThat(
            "cooldown not in effect for non-zero alliance",
            p.allianceCooldownInEffect(10), isFalse()
         );
         assertThat(
            "cooldown not in effect for zero-alliance",
            p.allianceCooldownInEffect(), isFalse()
         );
      }
   }
}
