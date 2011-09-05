package components.foliage
{
   import components.foliage.events.CFoliageSidebarMEvent;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   import models.ModelLocator;
   import models.exploration.ExplorationStatus;
   import models.exploration.events.ExplorationStatusEvent;
   import models.folliage.BlockingFolliage;
   
   import mx.events.PropertyChangeEvent;
   
   import namespaces.prop_name;
   
   import utils.EventUtils;
   
   
   /**
    * @see components.foliage.events.CFoliageSidebarMEvent.STATE_CHANGE
    * @eventType components.foliage.events.CFoliageSidebarMEvent.STATE_CHANGE
    */
   [Event(name="stateChange", type="components.foliage.events.CFoliageSidebarMEvent")]
   
   public class CFoliageSidebarM extends EventDispatcher
   {
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      private function get selectedFoliage() : BlockingFolliage {
         return ML.selectedFoliage;
      }
      
      private function get exploredFoliage() : BlockingFolliage {
         return ML.latestPlanet != null ? ML.latestPlanet.exploredFoliage : null;
      }
      
      private function get playerOwnsPlanet() : Boolean {
         return ML.latestPlanet != null && ML.latestPlanet.ssObject.ownerIsPlayer;
      }
      
      private function get planetNotInBattleground() : Boolean {
         return ML.latestPlanet == null || !ML.latestPlanet.inBattleground;
      }
      
      private function get planetNotInMiniBattleground() : Boolean {
         return ML.latestPlanet == null || !ML.latestPlanet.inMiniBattleground;
      }
      
      
      public function CFoliageSidebarM() {
         super();
         ML.addEventListener(
            PropertyChangeEvent.PROPERTY_CHANGE,
            ML_propertyChangeHandler, false, 0, true
         );
         explorationPanelModel.addEventListener(
            ExplorationStatusEvent.STATUS_CHANGE,
            explorationPanelModel_statusChangeHandler, false, 0, true
         );
         setFoliageModels();
      }
      
      
      [Bindable(event="willNotChange")]
      public const terraformPanelModel:CTerraformPanelM = new CTerraformPanelM();
      
      [Bindable(event="willNotChange")]
      public const explorationPanelModel:ExplorationStatus = ExplorationStatus.getInstance();
      
      [Bindable(event="stateChange")]
      public function get explorationPanelVisible() : Boolean {
         return selectedFoliage != null;
      }
      
      [Bindable(event="stateChange")]
      public function get terraformPanelVisible() : Boolean {
         return selectedFoliage != null &&
                exploredFoliage == null &&
                playerOwnsPlanet &&
                planetNotInBattleground &&
                planetNotInMiniBattleground;
      }
      
      private function ML_propertyChangeHandler(event:PropertyChangeEvent) : void {
         if (event.property == ModelLocator.prop_name::selectedFoliage) {
            setFoliageModels();
            dispatchStateChangeEvent();
         }
      }
      
      private function explorationPanelModel_statusChangeHandler(event:ExplorationStatusEvent) : void {
         dispatchStateChangeEvent();
      }
      
      private function setFoliageModels() : void {
         terraformPanelModel.foliage = selectedFoliage;
         explorationPanelModel.foliage = selectedFoliage;
      }
      
      private function dispatchStateChangeEvent() : void {
         EventUtils.dispatchSimpleEvent(this, CFoliageSidebarMEvent, CFoliageSidebarMEvent.STATE_CHANGE);
      }
   }
}