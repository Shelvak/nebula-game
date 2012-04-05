package models.player {
   import com.adobe.utils.ArrayUtil;

   import mx.collections.ArrayCollection;

   public class PlayerOptions {
      public static const IGNORE_TYPE_COMPLETE: String = 'complete';
      public static const IGNORE_TYPE_FILTERED: String = 'filtered';

      public static const TRANSPORTER_TAB_RESOURCES: int = 0;
      public static const TRANSPORTER_TAB_UNITS: int = 1;

      public static const TECH_SORT_TYPE_SCIENTISTS: int = 0;
      public static const TECH_SORT_TYPE_TIME: int = 1;

      public static function loadOptions (options: Object, justRefreshOriginalData: Boolean = false): void
      {
         originalData = options;
         hasChanges = false;
         if (justRefreshOriginalData)
         {
            originalIgnoredPlayers = ArrayUtil.copyArray(ignoredChatPlayers);
            return;
         }
         chatShowJoinLeave = options.chatShowJoinLeave;
         chatIgnoreType = options.chatIgnoreType;
         ignoredChatPlayers = options.ignoredChatPlayers;
         originalIgnoredPlayers = ArrayUtil.copyArray(ignoredChatPlayers);
         ignoredPlayersDataProvider = new ArrayCollection(ignoredChatPlayers);
         showPopupsAfterLogin = options.showPopupsAfterLogin;
         openFirstPlanetAfterLogin = options.openFirstPlanetAfterLogin;
         warnBeforeUnload = options.warnBeforeUnload;
         defaultTransporterTab = options.defaultTransporterTab;
         technologiesSortType = options.technologiesSortType;
         enablePlanetAnimations = options.enablePlanetAnimations;
      }

      private static var originalData: Object;
      private static var originalIgnoredPlayers: Array;
      
      public static function getOptions (): Object
      {
         return {
            'chatShowJoinLeave': chatShowJoinLeave,
            'chatIgnoreType': chatIgnoreType,
            'ignoredChatPlayers': ignoredChatPlayers,
            'showPopupsAfterLogin': showPopupsAfterLogin,
            'openFirstPlanetAfterLogin': openFirstPlanetAfterLogin,
            'warnBeforeUnload': warnBeforeUnload,
            'defaultTransporterTab': defaultTransporterTab,
            'technologiesSortType': technologiesSortType,
            'enablePlanetAnimations': enablePlanetAnimations
         }
      }

      public static function cancelChanges(): void
      {
         chatShowJoinLeave = originalData.chatShowJoinLeave;
         chatIgnoreType = originalData.chatIgnoreType;
         ignoredChatPlayers = ArrayUtil.copyArray(originalIgnoredPlayers);
         ignoredPlayersDataProvider.source = ignoredChatPlayers;
         showPopupsAfterLogin = originalData.showPopupsAfterLogin;
         openFirstPlanetAfterLogin = originalData.openFirstPlanetAfterLogin;
         warnBeforeUnload = originalData.warnBeforeUnload;
         defaultTransporterTab = originalData.defaultTransporterTab;
         technologiesSortType = originalData.technologiesSortType;
         enablePlanetAnimations = originalData.enablePlanetAnimations;
         hasChanges = false;
      }
      [Bindable]
      public static var hasChanges: Boolean = false;
      
      public static function changed(): void
      {
         hasChanges = !(chatShowJoinLeave == originalData.chatShowJoinLeave
         && chatIgnoreType == originalData.chatIgnoreType
         && ignoredChatPlayers.join(',') == originalIgnoredPlayers.join(',')
         && showPopupsAfterLogin == originalData.showPopupsAfterLogin
         && openFirstPlanetAfterLogin == originalData.openFirstPlanetAfterLogin
         && warnBeforeUnload == originalData.warnBeforeUnload
         && defaultTransporterTab == originalData.defaultTransporterTab
         && technologiesSortType == originalData.technologiesSortType
         && enablePlanetAnimations == originalData.enablePlanetAnimations);
      }

      public static function addIgnoredPlayer(playerName: String): void
      {
         ignoredPlayersDataProvider.addItem(playerName);
         changed();
      }

      public static function removeIgnoredPlayer(playerName: String): void
      {
         var idx: int = ignoredPlayersDataProvider.getItemIndex(playerName);
         if (idx == -1)
         {
            throw new Error("Player with name: " + playerName + " was not found " +
               "in ignored players list");
         }
         ignoredPlayersDataProvider.removeItemAt(idx);
         changed();
      }

      /*### Chat options ###*/
      [Bindable]
      public static var chatIgnoreType: String;
      [Bindable]
      public static var ignoredPlayersDataProvider: ArrayCollection;

      private static var ignoredChatPlayers: Array;
      [Bindable]
      public static var chatShowJoinLeave: Boolean;

      /*### After-login options ###*/

      [Bindable]
      public static var showPopupsAfterLogin: Boolean;
      [Bindable]
      public static var openFirstPlanetAfterLogin: Boolean;

      /*### Generic options ###*/

      [Bindable]
      public static var warnBeforeUnload: Boolean;
      [Bindable]
      public static var defaultTransporterTab: int;
      [Bindable]
      public static var technologiesSortType: int;
      [Bindable]
      public static var enablePlanetAnimations: Boolean = true;
   }
}
