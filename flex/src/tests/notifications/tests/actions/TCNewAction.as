package tests.notifications.tests.actions
{
   import com.developmentarc.core.actions.ActionDelegate;
   
   import controllers.CommunicationAction;
   import controllers.objects.ObjectsCommand;
   import controllers.objects.actions.CreatedAction;
   
   import models.ModelLocator;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   
   import tests.base.BaseTCAction;
   import tests.notifications.Data;

   public class TCNewAction extends BaseTCAction
   {
      protected override function getCommand():String
      {
         return ObjectsCommand.CREATED;
      }
      
      
      protected override function getAction():CommunicationAction
      {
         return new CreatedAction();
      }
      
      
      [Test]
      public function receiveMessage() : void
      {
         new ObjectsCommand(
            ObjectsCommand.CREATED, {"objectClass": "notification", "objects": [Data.notifOne]},
            true);
         assertThat( modelLoc.notifications, hasProperties({
            "notifsTotal": 1,
            "unreadNotifsTotal": 1,
            "newNotifsTotal": 1
         }));
         assertThat( modelLoc.notifications.getNotifAt(0).id, equalTo (1) );
         
         
         new ObjectsCommand(
            ObjectsCommand.CREATED, {"objectClass": "notification", "objects": [Data.notifTwo]},
            true);
         assertThat( modelLoc.notifications, hasProperties({
            "notifsTotal": 2,
            "unreadNotifsTotal": 2,
            "newNotifsTotal": 2
         }));
         assertThat( modelLoc.notifications.getNotifAt(1).id, equalTo (2) );
      };
   }
}