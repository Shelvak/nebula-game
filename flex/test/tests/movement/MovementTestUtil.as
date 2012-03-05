package tests.movement
{
   import config.Config;


   public class MovementTestUtil
   {
      internal static function setUp(speedModifierMin: Number = 0.1,
                                     speedModifierMax: Number = 2.0): void {
         Config.setConfig(
            {
               "combat.cooldown.afterJump.duration": 60,
               "units.move.modifier.min":            speedModifierMin,
               "units.move.modifier.max":            speedModifierMax,
               "creds.move.speedUp":                 "100 * percentage * hop_count",
               "creds.move.speedUp.maxCost":         500
            }
         );
      }

      internal static function tearDown(): void {
         Config.setConfig(new Object());
      }
   }
}
