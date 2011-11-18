package components.foliage
{
   import components.foliage.events.CFoliageSidebarMEvent;
   import components.popups.ActionConfirmationPopup;
   
   import config.Config;
   
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.RemoveFoliageActionParams;
   
   import flash.events.EventDispatcher;
   
   import flashx.textLayout.elements.TextFlow;
   
   import models.ModelLocator;
   import models.folliage.BlockingFolliage;
   import models.planet.MPlanet;
   import models.player.Player;
   import models.player.events.PlayerEvent;
   
   import spark.components.Button;
   import spark.components.RichText;
   import spark.utils.TextFlowUtil;
   
   import utils.Events;
   import utils.StringUtil;
   import utils.UrlNavigate;
   import utils.locale.Localizer;
   
   /**
    * @see components.foliage.events.CFoliageSidebarMEvent#STATE_CHANGE
    * @eventType components.foliage.events.CFoliageSidebarMEvent.STATE_CHANGE
    */
   [Event(name="stateChange", type="components.foliage.events.CFoliageSidebarMEvent")]
   
   public class CTerraformPanelM extends EventDispatcher
   {
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      private function get player() : Player {
         return ML.player;
      }
      
      private function get planet() : MPlanet {
         return ML.latestPlanet;
      }
      
      
      public function CTerraformPanelM() {
         super();
         player.addEventListener(PlayerEvent.CREDS_CHANGE, player_credsChangeHandler, false, 0, true);
      }
      
      
      private var _foliage:BlockingFolliage;
      public function set foliage(value:BlockingFolliage) : void {
         if (_foliage != value) {
            _foliage = value;
            dispatchStateChageEvent();
         }
      }
      public function get foliage() : BlockingFolliage {
         return _foliage;
      }
      
      [Bindable(event="stateChange")]
      public function get foliageRemovalCost() : int {
         if (_foliage != null)
            return Math.round(StringUtil.evalFormula(
               Config.getValue("creds.foliage.remove"),
               {"width": _foliage.width, "height": _foliage.height}
            ));
         else
            return 0;
      }
      
      [Bindable(event="stateChange")]
      public function get foliageRemovalCostTextFlow() : TextFlow {
         return TextFlowUtil.importFromString(getString("message.foliageRemovalCost", [foliageRemovalCost]));
      }
      
      [Bindable(event="stateChange")]
      public function get btnRemoveFoliageVisible() : Boolean {
         return player.creds >= foliageRemovalCost;
      }
      
      [Bindable(event="stateChange")]
      public function get btnBuyCredsVisible() : Boolean {
         return !btnRemoveFoliageVisible;
      }
      
      public function buyCreds() : void {
         UrlNavigate.getInstance().showBuyCreds();
      }
      
      public function removeFolliage() : void {
         var popup:ActionConfirmationPopup = new ActionConfirmationPopup();
         popup.title = getString("title.confirmTerraform");
         popup.cancelButtonLabel = getString("label.cancel");
         popup.cancelButtonEnabled = true;
         popup.confirmButtonLabel = getString("label.removeFoliage");
         popup.confirmButtonEnabled = true;
         popup.confirmButtonClickHandler = confirmButton_clickHandler;
         var message:RichText = new RichText();
         message.left = 0;
         message.right = 0;
         message.textFlow = TextFlowUtil.importFromString(
            getString("message.foliageRemovalConfirmation", [foliageRemovalCost])
         );
         popup.addElement(message);
         popup.show();
      }
      
      private function confirmButton_clickHandler(button:Button) : void {
         new PlanetsCommand(
            PlanetsCommand.REMOVE_FOLIAGE,
            new RemoveFoliageActionParams(planet.id, foliage.x, foliage.y)
         ).dispatch();
      }
      
      
      /* ############################## */
      /* ### PLAYER EVENTS HANDLING ### */
      /* ############################## */
      
      private function player_credsChangeHandler(event:PlayerEvent) : void {
         dispatchStateChageEvent();
      }
      
      
      /* ################### */
      /* ### STATIC TEXT ### */
      /* ################### */
      
      [Bindable(event="willNotChange")]
      public function get panelTitle() : String {
         return getString("title.terraform");
      }
      
      [Bindable(event="willNotChange")]
      public function get btnBuyCredsLabel() : String {
         return getString("label.buyCreds");
      }
      
      [Bindable(event="willNotChange")]
      public function get btnRemoveFoliageLabel() : String {
         return getString("label.removeFoliage");
      }
 
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function dispatchStateChageEvent() : void {
         Events.dispatchSimpleEvent(this, CFoliageSidebarMEvent, CFoliageSidebarMEvent.STATE_CHANGE);
      }
      
      private function getString(property:String, parameters:Array = null) : String {
         return Localizer.string("Terraform", property, parameters);
      }
   }
}