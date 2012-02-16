/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 2/16/12
 * Time: 12:02 PM
 * To change this template use File | Settings | File Templates.
 */
package models.player {
   public class PlayerOptions {
      public static function loadOptions (options: Object): void
      {
         chatShowJoinLeave = options.chatShowJoinLeave;
         chatIgnoreType = options.chatIgnoreType;
         ignoredChatPlayers = options.ignoredChatPlayers;
         showPopupsAfterLogin = options.showPopupsAfterLogin;
         openFirstPlanetAfterLogin = options.openFirstPlanetAfterLogin;
         warnBeforeUnload = options.warnBeforeUnload;
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

      /*### Chat options ###*/

      public static var chatIgnoreType: String;
      public static var ignoredChatPlayers: Array;
      public static var chatShowJoinLeave: Boolean;

      /*### After-login options ###*/

      public static var showPopupsAfterLogin: Boolean;
      public static var openFirstPlanetAfterLogin: Boolean;

      /*### Generic options ###*/

      public static var warnBeforeUnload: Boolean;
   }
}
