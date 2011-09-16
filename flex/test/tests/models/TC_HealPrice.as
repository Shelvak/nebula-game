package tests.models
{
   import config.Config;
   
   import models.healing.HealPrice;
   import models.unit.MCUnit;
   import models.unit.Unit;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   
   public class TC_HealPrice
   {
      private var units: Array = [];
      
      [Before]
      public function setUp() : void
      {
         Config.setConfig(
            { 
               'buildings.healingCenter.healing.cost.mod': '3 - 0.5 * (level-1)',
               'buildings.healingCenter.healing.time.mod': '1 - 0.2 * (level-1)',
               'units.shocker.metal.cost': '5',
               'units.shocker.energy.cost': '5.3',
               'units.shocker.zetium.cost': '9.1',
               'units.shocker.hp': '370',
               'units.seeker.metal.cost': '200',
               'units.seeker.energy.cost': '250',
               'units.seeker.zetium.cost': '150',
               'units.seeker.hp': '100'
            });
         
         var unit: Unit = new Unit();
         unit.hp = 50; // 13, 16, 26
         unit.type = 'Shocker';
         units.push(new MCUnit(unit));
         var unit1: Unit = new Unit();
         unit1.hp = 80; // 12, 14, 24
         unit1.type = 'Shocker';
         units.push(new MCUnit(unit1));
         var unit2: Unit = new Unit();
         unit2.hp = 99; //6, 8, 5
         unit2.type = 'Seeker';
         units.push(new MCUnit(unit2));
         var unit3: Unit = new Unit();
         unit3.hp = 85; // 90, 113, 68
         unit3.type = 'Seeker';
         units.push(new MCUnit(unit3));
         
      }
      
      [Test]
      public function testHealingPriceCalculation() : void
      {
         assertThat(HealPrice.calculateHealingPrice(units).metal, equalTo(121));
         assertThat(HealPrice.calculateHealingPrice(units.slice(0, 1)).energy, equalTo(16));
         assertThat(HealPrice.calculateHealingPrice(units.slice(1, 2)).energy, equalTo(14));
         assertThat(HealPrice.calculateHealingPrice(units.slice(2, 3)).energy, equalTo(8));
         assertThat(HealPrice.calculateHealingPrice(units.slice(3, 4)).energy, equalTo(113));
         assertThat(HealPrice.calculateHealingPrice(units).energy, equalTo(151));
         assertThat(HealPrice.calculateHealingPrice(units).zetium, equalTo(123));
         assertThat(HealPrice.calculateHealingPrice(units).cooldown, equalTo(626));
         
         assertThat(HealPrice.calculateHealingPrice(units.slice(0, 2)).metal, equalTo(25));
         assertThat(HealPrice.calculateHealingPrice(units.slice(0, 2)).energy, equalTo(30));
         assertThat(HealPrice.calculateHealingPrice(units.slice(0, 3)).zetium, equalTo(55));
      }
   }
}