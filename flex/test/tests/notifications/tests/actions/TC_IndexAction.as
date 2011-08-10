package tests.notifications.tests.actions
{
   import controllers.CommunicationAction;
   import controllers.notifications.NotificationsCommand;
   import controllers.notifications.actions.IndexAction;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   
   import tests.base.BaseTCAction;
   import tests.notifications.Data;

   public class TC_IndexAction extends BaseTCAction
   {		
      protected override function getCommand():String
      {
         return NotificationsCommand.INDEX;
      };
      
      
      protected override function getAction():CommunicationAction
      {
         return new IndexAction();
      };
      
      
      [Test]
      public function receiveMessage() : void
      {
         action.applyServerAction(new NotificationsCommand(
            NotificationsCommand.INDEX,
            {"notifications": Data.notificationsRaw}
         ));
         assertThat(
            modelLoc.notifications, hasProperties({
               "notifsTotal": 5,
               "unreadNotifsTotal": 2,
               "newNotifsTotal": 0
            })
         );
      }
   }
}