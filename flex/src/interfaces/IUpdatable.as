package interfaces
{
   /**
    * Objects implementing this interface need to be updated each second.
    * <code>utils.DateUtil.now</code> should be used as the current time value of the client.
    */
   public interface IUpdatable
   {
      /**
       * This method will be called each second so that object could update itself.
       */
      function update() : void;
      
      
      /**
       * Is invoked when new values have been read by all views to set all flags in
       * <code>change_flags</code> namespace to <code>false</code>.
       */
      function resetChangeFlags() : void;
   }
}