package components.base
{
   import flash.events.MouseEvent;
   
   
   
   
   /**
    * Components implementing this interface sets custom cursor
    * when mouse is over them.
    */
   public interface ICursorChanger
   {
      /**
       * Sets custom cursor. By default <code>GameCursorPriority.DEFAULT_CUSTOM</code>
       * is used for priority value.
       */
      function setCursor() : void;
      /**
       * Removes custom cursor.
       */
      function removeCursor() : void;
   }
}