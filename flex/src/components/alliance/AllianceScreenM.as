package components.alliance
{
   import components.alliance.events.AllianceScreenMEvent;
   import components.popups.ErrorPopup;

   import config.Config;

   import controllers.alliances.AlliancesCommand;
   import controllers.ui.NavigationController;

   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;

   import models.ModelLocator;
   import models.alliance.MAlliance;
   import models.events.HeaderEvent;
   import models.player.MRatingPlayer;
   import models.player.events.PlayerEvent;

   import mx.collections.Sort;
   import mx.collections.SortField;

   import spark.components.Button;

   import utils.DateUtil;
   import utils.Events;
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
      
      public static const nameField: SortField = new SortField('name', true);
      public static const rankField: SortField = new SortField('rank', false, false, true);
      public static const allianceField: SortField = new SortField('alliance', true);
      public static const victoryPtsField: SortField = new SortField('victoryPoints', false, true, true);
      public static const allianceVpsField: SortField = new SortField('allianceVps', false, true, true);
      public static const pointsField: SortField = new SortField('points', false, true, true);
      public static const deathDayField: SortField = new SortField('deathDate', false, true);
      public static const planetsCountField: SortField = new SortField('planetsCount', false, true, true);
      public static const bgPlanetsCountField: SortField = new SortField('bgPlanetsCount', false, true, true);
      public static const economyPtsField: SortField = new SortField('economyPoints', false, true, true);
      public static const sciencePtsField: SortField = new SortField('sciencePoints', false, true, true);
      public static const armyPtsField: SortField = new SortField('armyPoints', false, true, true);
      public static const warPtsField: SortField = new SortField('warPoints', false, true, true);
      
      private static const sortFields: Object = 
         {
            'rank':[rankField],
            'name':[nameField],
            'alliance':[allianceField, allianceVpsField, victoryPtsField,
               pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'planetsCount':[planetsCountField, bgPlanetsCountField, deathDayField,
               allianceVpsField, victoryPtsField, pointsField, nameField],
            'bgPlanetsCount':[bgPlanetsCountField, planetsCountField, deathDayField,
               allianceVpsField, victoryPtsField, pointsField, nameField],
            'economyPoints':[economyPtsField, allianceVpsField, victoryPtsField,
               pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'sciencePoints':[sciencePtsField, allianceVpsField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'armyPoints':[armyPtsField, allianceVpsField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'warPoints':[warPtsField, allianceVpsField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'victoryPoints':[victoryPtsField, allianceVpsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'allianceVps':[allianceVpsField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'points':[pointsField, allianceVpsField, victoryPtsField, bgPlanetsCountField, planetsCountField, nameField]
         }
      
      private static const inviteSortFields: Object = 
         {
            'rank':[rankField],
            'name':[nameField],
            'alliance':[allianceField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'planetsCount':[planetsCountField, bgPlanetsCountField, deathDayField,
               victoryPtsField, pointsField, nameField],
            'bgPlanetsCount':[bgPlanetsCountField, planetsCountField, deathDayField,
               victoryPtsField, pointsField, nameField],
            'economyPoints':[economyPtsField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'sciencePoints':[sciencePtsField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'armyPoints':[armyPtsField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'warPoints':[warPtsField, victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'victoryPoints':[victoryPtsField, pointsField, bgPlanetsCountField, planetsCountField, nameField],
            'points':[pointsField, victoryPtsField, bgPlanetsCountField, planetsCountField, nameField]
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
         MRatingPlayer.refreshRanks(_alliance.players);
      }
      
      public function header_inviteSortHandler(event:HeaderEvent):void
      {
         _alliance.invPlayers.sort = new Sort();
         _alliance.invPlayers.sort.fields = inviteSortFields[event.key];
         _alliance.invPlayers.refresh();
         MRatingPlayer.refreshRanks(_alliance.invPlayers);
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
            new AlliancesCommand(AlliancesCommand.LEAVE).dispatch();
            alliance = null;
         };
         popUp.show();
      }
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function dispatchSimpleEvent(type:String) : void {
         Events.dispatchSimpleEvent(this, AllianceScreenMEvent, type);
      }
   }
}