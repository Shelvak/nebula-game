package components.alliance
{
   import components.alliance.events.AllianceScreenMEvent;
   
   import controllers.alliances.AlliancesCommand;
   import controllers.ui.NavigationController;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   import models.ModelLocator;
   import models.alliance.MAlliance;
   import models.player.events.PlayerEvent;
   
   import utils.EventUtils;
   import utils.SingletonFactory;
   
   
   /**
    * @see components.alliance.events.AllianceScreenMEvent#TAB_SELECT
    * @eventType components.alliance.events.AllianceScreenMEvent.TAB_SELECT
    */
   [Event(name="tabSelect", type="components.alliance.events.AllianceScreenMEvent")]
   
   /**
    * @see components.alliance.events.AllianceScreenMEvent#ALLIANCE_CHANGE
    * @eventType components.alliance.events.AllianceScreenMEvent.ALLIANCE_CHANGE
    */
   [Event(name="allianceChange", type="components.alliance.events.AllianceScreenMEvent")]
   
   /**
    * @see components.alliance.events.AllianceScreenMEvent#MANAGEMENT_TAB_ENABLED_CHANGE
    * @eventType components.alliance.events.AllianceScreenMEvent.MANAGEMENT_TAB_ENABLED_CHANGE
    */
   [Event(name="managementTabEnabledChange", type="components.alliance.events.AllianceScreenMEvent")]
   
   
   /**
    * Model of <code>AllianceScreen</code> component for keeping UI state and implementation of
    * actions.
    */
   public class AllianceScreenM extends EventDispatcher
   {
      private static const TAB_DESCRIPTION:int = 0;
      private static const TAB_PLAYERS:int = 1;
      private static const TAB_MANAGEMENT:int = 2;
      
      
      public static function getInstance() : AllianceScreenM {
         return SingletonFactory.getSingletonInstance(AllianceScreenM);
      }
      
      
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      
      public function AllianceScreenM()
      {
         super();
         ML.player.addEventListener
            (PlayerEvent.ALLIANCE_ID_CHANGE, player_allianceIdChangeHandler, false, 0, true); 
      }
      
      
      private var _alliance:MAlliance = null;
      [Bindable(event="allianceChange")]
      public function set alliance(value:MAlliance) : void {
         if (_alliance != value)
         {
            _alliance = value;
            dispatchSimpleEvent(AllianceScreenMEvent.ALLIANCE_CHANGE);
         }
      }
      public function get alliance() : MAlliance {
         return _alliance;
      }
      
      
      /* ############ */
      /* ### TABS ### */
      /* ############ */
      
      
      private var _selectedTab:int = TAB_DESCRIPTION;
      
      
      private function selectTab(tabId:int) : void
      {
         _selectedTab = tabId;
         dispatchSimpleEvent(AllianceScreenMEvent.TAB_SELECT);
      }
      
      
      public function selectDescriptionTab() : void {
         selectTab(TAB_DESCRIPTION);
      }
      
      public function selectPlayersTab() : void {
         selectTab(TAB_PLAYERS);
      }      
      
      public function selectManagementTab() : void {
         if (_alliance != null && ML.player.belongsTo(_alliance.id))
            selectTab(TAB_MANAGEMENT);
      }
      
      
      private function isTabSelected(tabId:int) : Boolean
      {
         return _selectedTab == tabId;
      }
      
      
      [Bindable(event="tabSelect")]
      public function get descriptionTabSelected() : Boolean {
         return isTabSelected(TAB_DESCRIPTION);
      }
      
      [Bindable(event="tabSelect")]
      public function get playersTabSelected() : Boolean {
         return isTabSelected(TAB_PLAYERS);
      }
      
      [Bindable(event="tabSelect")]
      public function get managementTabSelected() : Boolean {
         return isTabSelected(TAB_MANAGEMENT);
      }
      
      
      private function get tabsEnabled() : Boolean {
         return _alliance != null;
      }
      
      [Bindable(event="allianceChange")]
      public function get descriptionTabEnabled() : Boolean {
         return tabsEnabled;
      }
      
      [Bindable(event="allianceChange")]
      public function get playersTabEnabled() : Boolean {
         return tabsEnabled;
      }
      
      [Bindable(event="managementTabEnabledChange")]
      [Bindable(event="allianceChange")]
      public function get managementTabEnabled() : Boolean {
         return tabsEnabled && ML.player.belongsTo(_alliance.id);
      }
      
      
      /* ################## */
      /* ### TAB PANELS ### */
      /* ################## */
      
      
      [Bindable(event="allianceChange")]
      [Bindable(event="tabSelect")]
      public function get descriptionPanelVisible() : Boolean {
         return descriptionTabEnabled && descriptionTabSelected;
      }
      
      [Bindable(event="allianceChange")]
      [Bindable(event="tabSelect")]
      public function get playersPanelVisible() : Boolean {
         return playersTabEnabled && playersTabSelected;
      }
      
      [Bindable(event="managementTabEnabledChange")]
      [Bindable(event="allianceChange")]
      [Bindable(event="tabSelect")]
      public function get managementPanelVisible() : Boolean {
         return managementTabEnabled && managementTabSelected;
      }
      
      
      public function showScreen(allianceId:int = 0) : void
      {
         if (allianceId > 0) new AlliancesCommand(AlliancesCommand.SHOW, {'id': allianceId}).dispatch();
         alliance = null;
         NAV_CTRL.showAllianceScreen();
         selectTab(TAB_DESCRIPTION);
      }
      
      
      /* ############################# */
      /* ### PLAYER EVENT HANDLERS ### */
      /* ############################# */
      
      
      private function player_allianceIdChangeHandler(event:PlayerEvent) : void
      {
         if (_alliance != null && !ML.player.belongsTo(_alliance.id) && managementTabSelected)
         {
            selectDescriptionTab();
         }
         dispatchSimpleEvent(AllianceScreenMEvent.MANAGEMENT_TAB_ENABLED_CHANGE);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function dispatchSimpleEvent(type:String) : void {
         EventUtils.dispatchSimpleEvent(this, AllianceScreenMEvent, type);
      }
   }
}