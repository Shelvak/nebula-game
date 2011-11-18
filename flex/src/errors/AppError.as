package errors
{
   /**
    * Base error for any custom errors used in the application. Mainly used to distinguish custom error
    * from those comming form third party libs, flex or flash code in tests.
    */
   public class AppError extends Error
   {
      public function AppError(message:* = "", id:* = 0) {
         super(message, id);
      }
   }
}