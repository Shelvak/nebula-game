package controllers.alliances.actions
{
   /**
    * Aggregates parameters of <code>controllers.alliance.actions.JoinAction</code> client command.
    * 
    * @see #JoinActionParams()
    * @see #notificationId
    * @see JoinAction
    */
   public class JoinActionParams
   {
      /**
       * See documentation of corresponding variables for information about parameters.
       * 
       * @see #notificationId
       */
      public function JoinActionParams(notificationId:int)
      {
         super();
         this.notificationId = notificationId;
      }
      
      
      /**
       * ID of a alliance invitation notification. 
       */
      public var notificationId:int;
   }
}