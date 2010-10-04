package tests.notifications.tests.actions
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.messages.MessageCommand;
   import controllers.notifications.NotificationsCommand;
   import controllers.notifications.actions.StarAction;
   
   import models.BaseModel;
   import models.notification.Notification;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   
   import tests.base.BaseTCAction;
   import tests.notifications.Data;

   public class TCStarAction extends BaseTCAction
   {		
      protected override function getCommand():String
      {
         return NotificationsCommand.STAR;
      }
      
      
      protected override function getAction():CommunicationAction
      {
         return new StarAction();
      };
      
      
      [Test(async, timeout=100)]
      public function sendMessage() : void
      {
         var notif:Notification = BaseModel.createModel(Notification, Data.notifOne);
         EventBroker.subscribe(
            MessageCommand.SEND_MESSAGE,
            asyncHandler(
               function(event:MessageCommand, passThroughData:Object) : void
               {
                  // Model should be marked as pending but [prop starred]
                  // should not have been changed yet
                  assertThat(
                     notif, hasProperties({
                        "pending": true,
                        "starred": false
                     })
                  );
                  // Server should receive correct parameters
                  assertThat(
                     event.rmo.parameters, hasProperties({
                        "id": Data.notifOne.id,
                        "mark": true
                     })
                  );
               },
               10
            )
         );
         action.applyClientAction(new NotificationsCommand(
            NotificationsCommand.STAR,
            {"notification": notif, "mark": true}
         ));
      };
      
      
      [Test]
      public function receiveResponse() : void
      {
         var notif:Notification = BaseModel.createModel(Notification, Data.notifOne);
         
         // Mark notification
         action.applyClientAction(new NotificationsCommand(
            NotificationsCommand.STAR,
            {"notification": notif, "mark": true}
         ));
         action.result();
         assertThat( notif.starred, equalTo (true) );
         
         // Now lets try to unmark the same notification
         action.applyClientAction(new NotificationsCommand(
            NotificationsCommand.STAR,
            {"notification": notif, "mark": false}
         ));
         action.result();
         assertThat( notif.starred, equalTo (false) );
      }
      
      
      include "../../../asyncHelpers.as";
   }
}