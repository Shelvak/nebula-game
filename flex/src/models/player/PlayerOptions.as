/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 2/16/12
 * Time: 12:02 PM
 * To change this template use File | Settings | File Templates.
 */
package models.player {
   import mx.collections.ArrayCollection;

   public class PlayerOptions {
      public static function loadOptions (options: Object): void
      {
         chatShowJoinLeave = options.chatShowJoinLeave;
         chatIgnoreType = options.chatIgnoreType;
         ignoredChatPlayers = options.ignoredChatPlayers;
         ignoredPlayersDataProvider = new ArrayCollection(ignoredChatPlayers);
         showPopupsAfterLogin = options.showPopupsAfterLogin;
         openFirstPlanetAfterLogin = options.openFirstPlanetAfterLogin;
         warnBeforeUnload = options.warnBeforeUnload;
         hasChanges = false;
      }
      
      public static function getOptions (): Object
      {
         return {
            'chatShowJoinLeave': chatShowJoinLeave,
            'chatIgnoreType': chatIgnoreType,
            'ignoredChatPlayers': ignoredChatPlayers,
            'showPopupsAfterLogin': showPopupsAfterLogin,
            'openFirstPlanetAfterLogin': openFirstPlanetAfterLogin,
            'warnBeforeUnload': warnBeforeUnload
         }
      }

      [Bindable]
      public static var hasChanges: Boolean = false;
      
      public static function changed(): void
      {
         hasChanges = true;
      }

      public static function addIgnoredPlayer(playerName: String): void
      {
         hasChanges = true;
         ignoredChatPlayers.push(playerName);
         ignoredPlayersDataProvider.addItem(playerName);
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
   }
}
