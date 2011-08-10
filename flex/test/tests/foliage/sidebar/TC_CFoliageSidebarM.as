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
         planet = new Planet(ssObject);
         model = new CFoliageSidebarM();
      }
      
      [After]
      public function tearDown() : void {
         model = null;
         selectedFoliage = null;
         planet = null;
      }
      
      [Test]
      public function explorationPanelVisibility() : void {
         selectedFoliage = null;
         assertThat( "if no foliage selected", model.explorationPanelVisible, isFalse() );
         
         selectedFoliage = new BlockingFolliage();
         assertThat( "if foliage selected", model.explorationPanelVisible, isTrue() );
      }
      
      [Test]
      public function terraformPanelVisibility() : void {
         selectedFoliage = null;
         assertThat(
            "if no foliage selected",
            model.terraformPanelVisible, isFalse()
         );         
         
         selectedFoliage = new BlockingFolliage();
         explorationEndsAt = null;
         assertThat(
            "if foliage selected and exploration is not underway",
            model.terraformPanelVisible, isTrue()
         );
         
         planet.addObject(selectedFoliage);
         explorationEndsAt = new Date(new Date().time + 1000);
         planet.ssObject.explorationX = 0;
         planet.ssObject.explorationY = 0;
         assertThat(
            "if foliage selected and this foliage is beeing explored",
            model.terraformPanelVisible, isFalse()
         );
         
         var foliage:BlockingFolliage = new BlockingFolliage();
         foliage.x = 3; foliage.xEnd = 3;
         foliage.y = 3; foliage.yEnd = 3;
         planet.addObject(foliage);
         planet.ssObject.explorationX = 3;
         planet.ssObject.explorationY = 3;
         assertThat(
            "if foliage selected and another foliage is beeing explored",
            model.terraformPanelVisible, isTrue()
         );
      }
      
      [Test]
      public function whenCreatedShouldSetFoliagePropertiesOnChildModels() : void {
         selectedFoliage = new BlockingFolliage();
         model = new CFoliageSidebarM();
         assertThat(
            "explorationPanelModel.foliage should be set",
            model.explorationPanelModel.foliage, equals (selectedFoliage)
         );
         assertThat(
            "terraformPanelModel.foliage should be set",
            model.terraformPanelModel.foliage, equals (selectedFoliage)
         );
      }
      
      [Test]
      public function foliageSelectionShouldUpdateFoliagePropertiesOnChildModels() : void {
         selectedFoliage = null;
         assertThat(
            "when selectedFoliage null, terraformPanelModel.foliage",
            model.terraformPanelModel.foliage, equals (selectedFoliage)
         );
         assertThat(
            "when selectedFoliage null, explorationPanelModel.foliage",
            model.explorationPanelModel.foliage, equals (selectedFoliage)
         );
         
         selectedFoliage = new BlockingFolliage();
         assertThat(
            "when selectedFoliage set, terraformPanelModel.foliage",
            model.terraformPanelModel.foliage, equals (selectedFoliage)
         );
         assertThat(
            "when selectedFoliage set, explorationPanelModel.foliage",
            model.explorationPanelModel.foliage, equals (selectedFoliage)
         );
      }
      
      [Test]
      public function stateChangeEventDispatching() : void {
         assertThat( "changing selected foliage",
            function():void{ selectedFoliage = new BlockingFolliage() }, triggersStateChangeEvent()
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
      
      private function set planet(value:Planet) : void {
         ML.latestPlanet = value;
      }
      private function get planet() : Planet {
         return ML.latestPlanet;
      }
      
      private function set selectedFoliage(value:BlockingFolliage) : void {
         ML.selectedFoliage = value;
      }
      private function get selectedFoliage() : BlockingFolliage {
         return ML.selectedFoliage;
      }
      
      private function set explorationEndsAt(value:Date) : void {
         planet.ssObject.explorationEndsAt = value;
      }
      
      private function triggersStateChangeEvent() : DispatchesMatcher {
         return causesTarget(model).toDispatchEvent(CFoliageSidebarMEvent.STATE_CHANGE);
      }
   }
}