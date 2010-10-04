package controllers.notifications
{
   import controllers.CommunicationCommand;
   
   public class NotificationsCommand extends CommunicationCommand
   {
      /**
       * @see controllers.notifications.actions.IndexAction
       */
      public static const INDEX:String = "notifications|index";
      
      /**
       * @see controllers.notifications.actions.ReadAction
       */
      public static const READ:String = "notifications|read";
      
      /**
       * @see controllers.notifications.actions.StarAction
       */
      public static const STAR:String = "notifications|star";
      
      
      public function NotificationsCommand(type:String,
                                           parameters:Object = null,
                                           fromServer:Boolean = false,
                                           eagerDispatch:Boolean = false)
      {
         super(type, parameters, fromServer, eagerDispatch);
      }
   }
}