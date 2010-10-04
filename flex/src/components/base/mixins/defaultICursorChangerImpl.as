// Here default ICursorChanger methods are defined together with cursor property.

import controllers.ui.GameCursorManager;
import controllers.ui.GameCursorPriority;

import flash.display.BitmapData;
import flash.events.MouseEvent;


/**
 * Custom cursor for this component.
 * 
 * @default null
 */ 
protected var cursor: BitmapData = null;
/**
 * Id of a cursor in a cursor manager.
 * 
 * @default GameCursorManager.NO_CURSOR_ID
 */
protected var cursorId:int = GameCursorManager.NO_CURSOR_ID;


/**
 * Indicates if this component has the custom cursor set.
 * 
 * @default false;
 */
public function get cursorSet() : Boolean
{
   return cursorId != GameCursorManager.NO_CURSOR_ID;
}


protected function setCursor_handler(event:MouseEvent) :void
{
   if (event.target == this && cursor)
   {
      setCursor();
   }
}
public function setCursor() : void
{
   if (cursorSet)
   {
      throw new Error("This component already has a custom cursor set.");
   }
   cursorId = GameCursorManager.getInstance().setCursor(cursor, GameCursorPriority.DEFAULT_CUSTOM);
}


protected function removeCursor_handler(event:MouseEvent) :void
{
   if (event.target == this)
   {
      removeCursor();
   }
}
public function removeCursor() : void
{
   if (cursorSet)
   {
      GameCursorManager.getInstance().removeCursor(cursorId);
      cursorId = GameCursorManager.NO_CURSOR_ID;
   }
}