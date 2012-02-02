/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 2/2/12
 * Time: 5:16 PM
 * To change this template use File | Settings | File Templates.
 */
package components.base {
   import flash.events.KeyboardEvent;

   import spark.components.List;

   public class NoKeyboardList extends List {
      public function NoKeyboardList() {
         super();
      }

      override protected function keyDownHandler(event:KeyboardEvent):void {
      }
   }
}
