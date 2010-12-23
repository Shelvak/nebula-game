package tests.notifications.tests.actions
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.CommunicationAction;
   import controllers.messages.MessageCommand;
   import controllers.notifications.NotificationsCommand;
   import controllers.notifications.actions.ReadAction;
   
   import models.BaseModel;
   import models.notification.Notification;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.hasProperty;
   
   import tests.base.BaseTCAction;
   import tests.notifications.Data;

   public class TCReadAction extends BaseTCAction
   {
      protected override function getCommand() : String
      {
         return NotificationsCommand.READ;
      };
      
      
      protected override function getAction() : CommunicationAction
      {
         return new ReadAction();
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
                  // Model should be marked as pending but [prop read]
                  // should not have been changed yet
                  assertThat(
                     notif, hasProperties({
                        "pending": true,
                        "read": false
                     })
                  );
                  // Server should receive correct parameters
                  assertThat( event.rmo.parameters, hasProperty ("ids", hasItem(Data.notifOne.id) ) );
               },
               10
            )
         );
         action.applyAction(new NotificationsCommand(
            NotificationsCommand.READ,
            {"notifications": [notif]}
         ));
      };
      
      
      [Test]
      public function receiveResponse() : void
      {
         var notif:Notification = BaseModel.createModel(Notification, Data.notifOne);
         notif.isNew = true;
         action.applyAction(new NotificationsCommand(
            NotificationsCommand.READ,
            {"notifications": [notif]}
         ));
         action.result();
         assertThat( notif.read, equalTo (true) );
         assertThat( notif.isNew, equalTo (false) );
      };
      
      
      include "../../../asyncHelpers.as";
   }
}