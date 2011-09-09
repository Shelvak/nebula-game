package components.alliance
{
   import components.alliance.events.AllianceScreenMEvent;
   import components.popups.ErrorPopup;
   import models.events.HeaderEvent;
   
   import config.Config;
   
   import controllers.GlobalFlags;
   import controllers.alliances.AlliancesCommand;
   import controllers.ui.NavigationController;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   import models.ModelLocator;
   import models.alliance.MAlliance;
   import models.player.events.PlayerEvent;
   
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   import spark.components.Button;
   
   import utils.DateUtil;
   import utils.EventUtils;
   import utils.SingletonFactory;
   import utils.locale.Localizer;
   
   
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
      
      private static const nameField: SortField = new SortField('name', true);
      private static const rankField: SortField = new SortField('rank', false, false, true);
      private static const allianceField: SortField = new SortField('alliance', true);
      private static const victoryPtsField: SortField = new SortField('victoryPoints', false, true, true);
      private static const allianceVpsField: SortField = new SortField('allianceVps', false, true, true);
      private static const pointsField: SortField = new SortField('points', false, true, true);
      private static const planetsCountField: SortField = new SortField('planetsCount', false, true, true);
      private static const economyPtsField: SortField = new SortField('economyPoints', false, true, true);
      private static const sciencePtsField: SortField = new SortField('sciencePoints', false, true, true);
      private static const armyPtsField: SortField = new SortField('armyPoints', false, true, true);
      private static const warPtsField: SortField = new SortField('warPoints', false, true, true);
      
      private static const sortFields: Object = 
         {
            'rank':[rankField],
            'name':[nameField],
            'alliance':[allianceField, allianceVpsField, victoryPtsField, pointsField, planetsCountField, nameField],
            'planetsCount':[planetsCountField, allianceVpsField, victoryPtsField, pointsField, nameField],
            'economyPoints':[economyPtsField, allianceVpsField, victoryPtsField, pointsField, planetsCountField, nameField],
            'sciencePoints':[sciencePtsField, allianceVpsField, victoryPtsField, pointsField, planetsCountField, nameField],
            'armyPoints':[armyPtsField, allianceVpsField, victoryPtsField, pointsField, planetsCountField, nameField],
            'warPoints':[warPtsField, allianceVpsField, victoryPtsField, pointsField, planetsCountField, nameField],
            'victoryPoints':[victoryPtsField, allianceVpsField, pointsField, planetsCountField, nameField],
            'allianceVps':[allianceVpsField, victoryPtsField, pointsField, planetsCountField, nameField],
            'points':[pointsField, allianceVpsField, victoryPtsField, planetsCountField, nameField]
         }
      
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
      
      private var sortKey: String;
      
      public function reset() : void {
         alliance = null;
         selectDescriptionTab();
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
            selectDescriptionTab();
         dispatchSimpleEvent(AllianceScreenMEvent.MANAGEMENT_TAB_ENABLED_CHANGE);
      }
      
      /* ################ */
      /* ### HANDLERS ### */
      /* ################ */
      
      
      public function header_ratingsSortHandler(event:HeaderEvent):void
      {
         _alliance.players.sort = new Sort();
         _alliance.players.sort.fields = sortFields[event.key];
         _alliance.players.refresh();
      }
      
      public function refresh_clickHandler(event:MouseEvent):void
      {
         new AlliancesCommand(AlliancesCommand.SHOW, {'id': alliance.id}).dispatch();
      }
      
      public function leave_clickHandler(event:MouseEvent):void
      {
         var popUp: ErrorPopup = new ErrorPopup();
         popUp.retryButtonLabel = Localizer.string('Popups', 'label.yes');
         popUp.cancelButtonLabel = Localizer.string('Popups', 'label.no');
         popUp.showCancelButton = true;
         popUp.showRetryButton = true;
         popUp.message = alliance.ownerId == ML.player.id
            ? Localizer.string('Popups', 'message.leaveSelfAlly')
            : Localizer.string('Popups', 'message.leaveAlly', 
               [DateUtil.secondsToHumanString(Config.getAllianceLeaveCooldown())]);
         popUp.title = Localizer.string('Popups', 'title.leaveAlly');
         popUp.retryButtonClickHandler = function (button: Button = null): void
         {
            GlobalFlags.getInstance().lockApplication = true;
            new AlliancesCommand(AlliancesCommand.LEAVE).dispatch();
            alliance = null;
         };
         popUp.show();
      }
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function dispatchSimpleEvent(type:String) : void {
         EventUtils.dispatchSimpleEvent(this, AllianceScreenMEvent, type);
      }
   }
}