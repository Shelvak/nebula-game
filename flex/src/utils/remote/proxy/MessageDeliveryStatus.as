package utils.remote.proxy
{
   /**
    * Defines available satuses for delivered or canceled messages.
    */
   public final class MessageDeliveryStatus
   {
      /**
       * The message has been delivered successfully.
       */
      public static const COMPLETE:uint = 0;
      
      
      /**
       * The message could not be delivered due to an error.
       */
      public static const ERROR:uint = 1;
      
      
      /**
       * The message has been canceled because another message sent prior this one has completed with error.
       */
      public static const CANCEL:uint = 2;
   }
}