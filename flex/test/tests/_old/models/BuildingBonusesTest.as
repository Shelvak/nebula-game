package tests._old.models
{
   import models.building.BuildingBonuses;
   
   import org.flexunit.asserts.assertEquals;
   
   public class BuildingBonusesTest
   {
      
      [Test]
      public function getBonusesSum () :void
      {
         var test1: BuildingBonuses = new BuildingBonuses();
         var test2: BuildingBonuses = new BuildingBonuses();
         
         test1.armor = -2;
         test1.energyOutput = 5;
         test1.constructionTime = 2;
         
         test2.armor = 0;
         test2.energyOutput = 3;
         test2.constructionTime = -8;
         
         var tc: BuildingBonuses = BuildingBonuses.getBonusesSum(test1, test2);
         
         assertEquals("Hit points bonus should be -2", -2, tc.armor);
         assertEquals("Energy output bonus should be 8", 8, tc.energyOutput);
         assertEquals("Construction time bonus should be -6", -6, tc.constructionTime);
         
         
         test1.armor = 1;
         test1.energyOutput = 1;
         test1.constructionTime = 1;
         
         test2.armor = -1;
         test2.energyOutput = 3;
         test2.constructionTime = -1;
         
         tc = BuildingBonuses.getBonusesSum(test1, test2);
         
         assertEquals("Hit points bonus should be 0", 0, tc.armor);
         assertEquals("Energy output bonus should be 4", 4, tc.energyOutput);
         assertEquals("Construction time bonus should be 0", 0, tc.constructionTime);
      }
   }
}