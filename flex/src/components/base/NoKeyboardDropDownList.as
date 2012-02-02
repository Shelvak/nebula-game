/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 2/2/12
 * Time: 6:44 PM
 * To change this template use File | Settings | File Templates.
 */
package components.base {
   import flash.events.KeyboardEvent;

   import spark.components.DropDownList;

   public class NoKeyboardDropDownList extends DropDownList {
      public function NoKeyboardDropDownList() {
      }

      protected override function keyDownHandler(e: KeyboardEvent): void
      {

      }
   }
}
