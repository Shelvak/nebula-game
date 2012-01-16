package tests.foliage.sidebar
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.framework.SetupResult;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import components.foliage.CTerraformPanelM;
   import components.foliage.events.CFoliageSidebarMEvent;
   
   import config.Config;
   
   import controllers.startup.StartupInfo;
   
   import ext.hamcrest.events.DispatchesMatcher;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;
   import ext.mocks.Mock;

   import models.ModelLocator;
   import models.folliage.BlockingFolliage;
   
   import mx.resources.IResourceManager;
   import mx.resources.ResourceBundle;
   import mx.resources.ResourceManager;
   
   import namespaces.client_internal;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   
   import utils.SingletonFactory;
   import utils.UrlNavigate;
   import utils.locale.Locale;
   
   
   public class TC_CTerraformPanelM
   {
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      private function get RM() : IResourceManager {
         return ResourceManager.getInstance();
      }
      
      [Rule]
      public var includeMocks:IncludeMocksRule = new IncludeMocksRule([UrlNavigate]);
      
      /**
       * Is available between <code>setUp()</code> and <code>tearDown()</code>.
       */
      protected var mockRepository:MockRepository;
      
      private var model:CTerraformPanelM;
      
      [Before]
      public function setUp() : void {
         mockRepository = new MockRepository();
         Mock.singleton(mockRepository, UrlNavigate);
         SetupResult.forCall(
            UrlNavigate.getInstance().getWikiUrlRoot()
         ).returnValue(null);
         
         StartupInfo.getInstance().locale = Locale.EN;
         var rb:ResourceBundle = new ResourceBundle(Locale.EN, "Terraform");
         rb.content["title.terraform"] = "Terraform";
         rb.content["label.buyCreds"] = "Buy creds";
         rb.content["label.removeFoliage"] = "Remove";
         rb.content["message.foliageRemovalCost"] = 'You can remove this object for <span fontWeight="bold">4</span> creds.';
         RM.addResourceBundle(rb);
         RM.update();
         
         // 1 cred for a tile
         Config.setConfig({"creds.foliage.remove": "height * width"});
         
         var foliage:BlockingFolliage = new BlockingFolliage();
         foliage.x = foliage.y = 0;
         foliage.xEnd = foliage.yEnd = 1;
         
         model = new CTerraformPanelM();
         model.foliage = foliage;
      }
      
      [After]
      public function tearDown() : void {
         model = null;
         RM.removeResourceBundlesForLocale(Locale.EN);
         mockRepository = null;
         SingletonFactory.clearAllSingletonInstances();
      }
      
      [Test]
      public function foliageRemovalCost() : void {
         assertThat( "foliage removal cost value",
            model.foliageRemovalCost, equals (4)
         );
         assertThat( "foliage removal cost message",
            model.foliageRemovalCostTextFlow.getText(), equals ("You can remove this object for 4 creds.")
         );
      }
      
      [Test]
      public function removeFoliageAndBuyCreditsButtonsVisibility() : void {
         ML.player.creds = 10;
         assertThat( "btn to remove foliage visible when player has more creds than needed",
            model.btnRemoveFoliageVisible, isTrue()
         );
         assertThat( "btn to buy creds not visible when player has more creds than needed",
            model.btnBuyCredsVisible, isFalse()
         );
         
         ML.player.creds = 4;
         assertThat( "btn to remove foliage visible when player has exact amount of creds",
            model.btnRemoveFoliageVisible, isTrue()
         );
         assertThat( "btn to buy creds not visible when player has exact amount of creds",
            model.btnBuyCredsVisible, isFalse()
         );
         
         ML.player.creds = 3;
         assertThat( "btn to remove foliage not visible when player does not have enough creds",
            model.btnRemoveFoliageVisible, isFalse()
         );
         assertThat( "btn to buy creds visible when player does not have enough creds",
            model.btnBuyCredsVisible, isTrue()
         );
      }
      
      [Test]
      public function staticLabels() : void {
         mockRepository.replayAll();
         assertThat( "panel title", model.panelTitle, equals ("Terraform") );
         assertThat( "btn buy creds label", model.btnBuyCredsLabel, equals ("Buy creds") );
         assertThat( "btn remove foliage label", model.btnRemoveFoliageLabel, equals ("Remove") );
      }
      
      [Test]
      public function stateChangeEventDispatching() : void {
         assertThat( "changing player credits",
            function():void{ ML.player.creds = 100}, triggersStateChangeEvent()
         );
         assertThat( "setting foliage to another instance",
            function():void{ model.foliage = new BlockingFolliage() }, triggersStateChangeEvent()
         );
         assertThat( "setting foliage to null",
            function():void{ model.foliage = null }, triggersStateChangeEvent()
         );
      }
      
      [Test]
      public function buyCreditsAction() : void {
         Expect.call(UrlNavigate.getInstance().showBuyCreds());
         mockRepository.replayAll();
         model.buyCreds();
         mockRepository.verifyAll();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function triggersStateChangeEvent() : DispatchesMatcher {
         return causes (model) .toDispatchEvent (CFoliageSidebarMEvent.STATE_CHANGE)
      }
   }
}