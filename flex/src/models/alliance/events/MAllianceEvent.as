/**
 * Created by IntelliJ IDEA.
 * User: MikisM
 * Date: 12.1.9
 * Time: 11.07
 * To change this template use File | Settings | File Templates.
 */
package models.alliance.events
{
   import flash.events.Event;


   public class MAllianceEvent extends Event
   {
      public static const OWNER_CHANGE:String = "ownerChange";

      public function MAllianceEvent(type:String) {
         super(type);
      }
   }
}
