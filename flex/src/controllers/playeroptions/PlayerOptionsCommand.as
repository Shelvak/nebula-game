/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 2/16/12
 * Time: 11:57 AM
 * To change this template use File | Settings | File Templates.
 */
package controllers.playeroptions
{
   import controllers.CommunicationCommand;

   /**
    * Used for receiving player options after startup.
    */
   public class PlayerOptionsCommand extends CommunicationCommand
   {
      public static const SHOW:String = "player_options|show";
      public static const SET:String = "player_options|set";

      /**
       * Constructor.
       */
      public function PlayerOptionsCommand
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}