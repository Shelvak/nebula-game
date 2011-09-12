package utils.logging
{
   import mx.core.mx_internal;
   import mx.logging.targets.LineFormattedTarget;
   
   use namespace mx_internal;
   
   
   /**
    * Logging target that stores messages in memory - array of strings.
    */
   public class InMemoryTarget extends LineFormattedTarget
   {
      public function InMemoryTarget()
      {
         super();
         _content = new Vector.<String>();
      }
      
      
      private var _maxEntries:uint = 0;
      /**
       * Maximum numbe of latest entries to store. If this is <code>0</code>, all entries are stored until
       * you run out of memory. Default is <code>0<code>.
       */
      public function set maxEntries(value:uint) : void
      {
         _maxEntries = value;
         removeExceedingEntries();
      }
      /**
       * @private
       */
      public function get maxEntries() : uint
      {
         return _maxEntries;
      }
      
      
      private var _content:Vector.<String>;
      /**
       * Returns all log entries logged in this target as one string.
       * 
       * @param sep a delimiter to use for joining enties.
       */
      public function getContent(sep:String = "\n") : String
      {
         return _content.join(sep);
      }
      
      
      /**
       * Removes all entries logged until now and returns them.
       */
      public function clear() : void
      {
         _content.splice(0, _content.length);
      }
      
      
      override mx_internal function internalLog(message:String) : void
      {
         _content.push(message);
         removeExceedingEntries();
      }
      
      
      /**
       * Removes oldest entries and leaves at most <code>_maxEntries</code> in memory if this restriction
       * is in effect.
       */
      private function removeExceedingEntries() : void
      {
         if (_maxEntries > 0 && _content.length > _maxEntries)
         {
            _content.splice(0, _content.length - _maxEntries);
         }
      }
   }
}