package utils.remote.proxy
{
   /**
    * Aggregates configuration properties of <code>LargeMessageSender</code> instance.
    */
   public class LargeMessageSenderConfig
   {
      /**
       * You can set the values of all or any properties of the configuration instance by passing a generic
       * object containing propeties you need named the same as the properties of this class.
       */
      public function LargeMessageSenderConfig(params:Object = null)
      {
         if (!params)
         {
            return;
         }
         if (params.retryAfterFailure)
         {
            retryAfterFailure = params.retryAfterFailure;
         }
         if (params.maxRetryCount)
         {
            maxRetries = params.maxRetryCount;
         }
         if (params.cancelAllCallsAfterError)
         {
            cancelAllCallsAfterError = params.cancelAllCallsAfterError;
         }
      }
      
      
      /**
       * Number of times a failed call should be repeated before the <code>completeHandler</code> is called
       * with the error status event. Set this to negative value and <code>LargeMessageSender</code> will
       * repeat the call until it succeeds. For this property to have any effect,
       * <code>retryAfterFailure</code> property must be set to <code>true</code>.
       * 
       * @default -1
       */
      public var maxRetries:int = -1;
      
      
      /**
       * Indicates if a failed call should be retried again before dispatching error event. The maximum
       * number of retries is defined by <code>maxRetries</code>. 
       * 
       * @default false
       */
      public var retryAfterFailure:Boolean = false;
      
      
      /**
       * Whether all scheduled calls should be canceled if one of the calls is unsuccessful. If this is set
       * to <code>false</code>, only the call which failed will be canceled. If that failed call was a
       * multi-packet call and it failed in the middle, <code>LargeMessageSender</code> will cancel all
       * packets left for that call but will try to inform of this situation the receiver by calling a method
       * without any parameters named <code>LargeMessageSender.MULTI_PACKET_CANCEL_METHOD</code>.
       * 
       * @default false
       */
      public var cancelAllCallsAfterError:Boolean = false;
   }
}