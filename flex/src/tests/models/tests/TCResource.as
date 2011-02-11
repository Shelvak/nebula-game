package tests.models.tests
{
   import config.Config;
   
   import models.resource.Resource;
   
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceBundle;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   
   public class TCResource
   {
      
      [Before]
      public function setUp() : void
      {
         Config.setConfig(
            { 
               'buildings.selfDestruct.resourceGain': '50',
               'buildings.building.metal.cost': 'level+4',
               'buildings.building.energy.cost': 'level*1.3'
            });
            
      }
      
      [Test]
      public function testBuildingDestructRevenue() : void
      {
         assertThat(Resource.calculateBuildingDestructRevenue('Building', 2, 'metal'), equalTo("6"));
         assertThat(Resource.calculateBuildingDestructRevenue('Building', 1, 'metal'), equalTo("3"));
         assertThat(Resource.calculateBuildingDestructRevenue('Building', 3, 'energy'), equalTo("5"));
      }
   }
}