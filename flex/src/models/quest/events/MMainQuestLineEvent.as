/**
 * Created by IntelliJ IDEA.
 * User: MikisM
 * Date: 12.1.2
 * Time: 11.32
 * To change this template use File | Settings | File Templates.
 */
package models.quest.events
{
   import flash.events.Event;


   public class MMainQuestLineEvent extends Event
   {
      public static const CURRENT_PRESENTATION_CHANGE:String = "currentPresentationChange";
      public static const IS_OPEN_CHANGE:String = "isOpenChange";
      public static const SHOW_BUTTON_CHANGE:String = "showButtonChange";

      public function MMainQuestLineEvent(type:String) {
         super(type);
      }
   }
}
