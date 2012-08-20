package models.player {
   import com.adobe.utils.ArrayUtil;

   import controllers.sounds.SoundsController;

   import controllers.sounds.SoundsController;

   import models.sound.MSound;

   import mx.collections.ArrayCollection;

   import utils.locale.Localizer;

   public class PlayerOptions {
      public static const IGNORE_TYPE_COMPLETE: String = 'complete';
      public static const IGNORE_TYPE_FILTERED: String = 'filtered';

      public static const TRANSPORTER_TAB_RESOURCES: int = 0;
      public static const TRANSPORTER_TAB_UNITS: int = 1;

      public static const TECH_SORT_TYPE_SCIENTISTS: int = 0;
      public static const TECH_SORT_TYPE_TIME: int = 1;

      public static const MIN_EVENT_SHOW_TIME: int = 1;
      public static const MAX_EVENT_SHOW_TIME: int = 30;

      public static const NO_SOUND: String = "";

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
         showWormholeIcons = options.showWormholeIcons;
         showInfoEvents = options.showInfoEvents;
         actionEventTime = options.actionEventTime;
         notificationEventTime = options.notificationEventTime;
         soundForNotification = options.soundForNotification;
         soundForPrivateMsg = options.soundForPrivateMsg;
         soundForAllianceMsg = options.soundForAllianceMsg;
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
            'enablePlanetAnimations': enablePlanetAnimations,
            'showWormholeIcons': showWormholeIcons,
            'showInfoEvents': showInfoEvents,
            'actionEventTime': actionEventTime,
            'notificationEventTime': notificationEventTime,
            'soundForNotification': soundForNotification,
            'soundForPrivateMsg': soundForPrivateMsg,
            'soundForAllianceMsg': soundForAllianceMsg
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
         showWormholeIcons = originalData.showWormholeIcons;
         showInfoEvents = originalData.showInfoEvents;
         actionEventTime = originalData.actionEventTime;
         notificationEventTime = originalData.notificationEventTime;
         soundForNotification = originalData.soundForNotification;
         soundForPrivateMsg = originalData.soundForPrivateMsg;
         soundForAllianceMsg = originalData.soundForAllianceMsg;
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
         && enablePlanetAnimations == originalData.enablePlanetAnimations
         && showWormholeIcons == originalData.showWormholeIcons
         && showInfoEvents == originalData.showInfoEvents
         && actionEventTime == originalData.actionEventTime
         && notificationEventTime == originalData.notificationEventTime
         && soundForNotification == originalData.soundForNotification
         && soundForPrivateMsg == originalData.soundForPrivateMsg
         && soundForAllianceMsg == originalData.soundForAllianceMsg);
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
      public static var showInfoEvents: Boolean;
      [Bindable]
      public static var actionEventTime: int;
      [Bindable]
      public static var notificationEventTime: int;

      /*### Map options ###*/

      [Bindable]
      public static var enablePlanetAnimations: Boolean = true;

      [Bindable]
      public static var showWormholeIcons: Boolean = true;

      /*### Sound options ###*/

      private static var notificationSoundsCollection: ArrayCollection;

      public static function notificationSounds(): ArrayCollection
      {
         if (notificationSoundsCollection != null) {
            return notificationSoundsCollection;
         }

         var names: Array = [];
         var sounds: Vector.<MSound> = SoundsController.filter(
            function(sound: MSound): Boolean {
               return sound.name.
                  indexOf(SoundsController.NOTIFICATION_PREFIX) == 0;
            }
         );

         for each (var sound: MSound in sounds) {
            names.push(
               new PlayerSoundOption(sound.basename, sound.basename, sound)
            );
         }
         names.sortOn("name");

         // For 'none' in sound selection.
         names.unshift(
            new PlayerSoundOption(
               Localizer.string('PlayerOptions', 'label.noSound'), NO_SOUND,
               null
            )
         );

         notificationSoundsCollection = new ArrayCollection(names);
         return notificationSoundsCollection;
      }

      public static function notificationSoundIndex(value: String): int
      {
         var options: Array = notificationSounds().source;
         var index: uint = 0;
         for each (var soundOption: PlayerSoundOption in options) {
            if (soundOption.value == value) {
               return index;
            }
            else {
               index++;
            }
         }

         return -1;
      }

      [Bindable]
      public static var soundForNotification: String = NO_SOUND;

      [Bindable]
      public static var soundForPrivateMsg: String = NO_SOUND;

      [Bindable]
      public static var soundForAllianceMsg: String = NO_SOUND;
   }
}
