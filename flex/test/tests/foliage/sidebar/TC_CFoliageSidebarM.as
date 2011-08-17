package tests.foliage.sidebar
{
   import components.foliage.CFoliageSidebarM;
   import components.foliage.events.CFoliageSidebarMEvent;
   
   import ext.hamcrest.events.DispatchesMatcher;
   import ext.hamcrest.events.causesTarget;
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.folliage.BlockingFolliage;
   import models.planet.Planet;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   
   
   public class TC_CFoliageSidebarM
   {
      private var model:CFoliageSidebarM;
      
      [Before]
      public function setUp() : void {
         var ssObject:MSSObject = new MSSObject();
         ssObject.type = SSObjectType.PLANET;
         ssObject.width = 5;
         ssObject.height = 5;
         ML.latestPlanet = new Planet(ssObject);
         model = new CFoliageSidebarM();
      }
      
      [After]
      public function tearDown() : void {
         model = null;
         ML.latestPlanet = null;
         ML.selectedFoliage = null;
      }
      
      [Test]
      public function explorationPanelVisibility() : void {
         ML.selectedFoliage = null;
         assertThat( "if no foliage selected", model.explorationPanelVisible, isFalse() );
         
         ML.selectedFoliage = new BlockingFolliage();
         assertThat( "if foliage selected", model.explorationPanelVisible, isTrue() );
      }
      
      [Test]
      public function terraformPanelVisibility() : void {
         ML.selectedFoliage = null;
         assertThat(
            "if no foliage selected",
            model.terraformPanelVisible, isFalse()
         );         
         
         ML.selectedFoliage = new BlockingFolliage();
         explorationEndsAt = null;
         assertThat(
            "if foliage selected and exploration is not underway",
            model.terraformPanelVisible, isTrue()
         );
         
         ML.latestPlanet.addObject(ML.selectedFoliage);
         explorationEndsAt = new Date(new Date().time + 1000);
         ML.latestPlanet.ssObject.explorationX = 0;
         ML.latestPlanet.ssObject.explorationY = 0;
         assertThat(
            "if foliage selected and this foliage is beeing explored",
            model.terraformPanelVisible, isFalse()
         );
         
         var foliage:BlockingFolliage = new BlockingFolliage();
         foliage.x = 3; foliage.xEnd = 3;
         foliage.y = 3; foliage.yEnd = 3;
         ML.latestPlanet.addObject(foliage);
         ML.latestPlanet.ssObject.explorationX = 3;
         ML.latestPlanet.ssObject.explorationY = 3;
         assertThat(
            "if foliage selected and another foliage is beeing explored",
            model.terraformPanelVisible, isFalse()
         );
      }
      
      [Test]
      public function whenCreatedShouldSetFoliagePropertiesOnChildModels() : void {
         ML.selectedFoliage = new BlockingFolliage();
         model = new CFoliageSidebarM();
         assertThat(
            "explorationPanelModel.foliage should be set",
            model.explorationPanelModel.foliage, equals (ML.selectedFoliage)
         );
         assertThat(
            "terraformPanelModel.foliage should be set",
            model.terraformPanelModel.foliage, equals (ML.selectedFoliage)
         );
      }
      
      [Test]
      public function foliageSelectionShouldUpdateFoliagePropertiesOnChildModels() : void {
         ML.selectedFoliage = null;
         assertThat(
            "when selectedFoliage null, terraformPanelModel.foliage",
            model.terraformPanelModel.foliage, equals (ML.selectedFoliage)
         );
         assertThat(
            "when selectedFoliage null, explorationPanelModel.foliage",
            model.explorationPanelModel.foliage, equals (ML.selectedFoliage)
         );
         
         ML.selectedFoliage = new BlockingFolliage();
         assertThat(
            "when selectedFoliage set, terraformPanelModel.foliage",
            model.terraformPanelModel.foliage, equals (ML.selectedFoliage)
         );
         assertThat(
            "when selectedFoliage set, explorationPanelModel.foliage",
            model.explorationPanelModel.foliage, equals (ML.selectedFoliage)
         );
      }
      
      [Test]
      public function stateChangeEventDispatching() : void {
         assertThat( "changing selected foliage",
            function():void{ ML.selectedFoliage = new BlockingFolliage() }, triggersStateChangeEvent()
         );
         assertThat( "starting exploration",
            function():void{ explorationEndsAt = new Date(new Date().time + 1000) }, triggersStateChangeEvent()
         );
         assertThat( "completing exploration",
            function():void{ explorationEndsAt = null }, triggersStateChangeEvent()
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      private function set explorationEndsAt(value:Date) : void {
         ML.latestPlanet.ssObject.explorationEndsAt = value;
      }
      
      private function triggersStateChangeEvent() : DispatchesMatcher {
         return causesTarget(model).toDispatchEvent(CFoliageSidebarMEvent.STATE_CHANGE);
      }
   }
}