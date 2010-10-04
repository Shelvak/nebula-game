package errors
{
   /**
    * Base error class for all custom errors in the application. You can and <strong>should</strong>
    * throw instances of this class rather than <code>Error</code> to make testing available.
    */
   public class BaseError extends Error
   {
      public function BaseError(message:*="", id:*=0)
      {
         super(message, id);
      }
   }
}