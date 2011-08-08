package tests.chat.actions
{
   import asmock.framework.Expect;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePrivateAction;
   import controllers.chat.actions.MessagePrivateActionParams;
   import controllers.messages.MessagesProcessor;
   
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatMessage;
   
   import namespaces.client_internal;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   
   import utils.DateUtil;
   import utils.SingletonFactory;
   import utils.remote.rmo.ClientRMO;
   
   
   public class TC_MessagePrivateAction extends TC_BaseChatAction
   {
      public function TC_MessagePrivateAction()
      {
         super();
      }
      
      
      public override function classesToMock() : Array
      {
         return super.classesToMock().concat(MessagesProcessor);
      }
      
      
      private var action:MessagePrivateAction;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         action = new MessagePrivateAction();
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         action = null;
      };
      
      
      [Test]
      public function when_received_from_server_should_retrieve_message_from_pool_and_notify_MChat() : void
      {
         var params:Object = {
            "pid": 1,
            "msg": "This is an important message: give me my planet back!"
         };
         
         Expect.call(MCHAT.receivePrivateMessage(null))
            .ignoreArguments()
            .doAction(function(message:MChatMessage) : void
            {
               assertThat( message, hasProperties ({
                  "playerId": params.pid,
                  "message": params.msg
               }));
            });
         
         mockRepository.replayAll();
         
         // No instances of MChatMessage should have been borrowed before the operation
         assertThat( MCHAT.messagePool.numActive, equals (0) );
         
         action.applyAction(new ChatCommand(ChatCommand.MESSAGE_PRIVATE, params, true));
         
         // One instance of MChatMessage should have been borrowed from the pool
         assertThat( MCHAT.messagePool.numActive, equals (1) );
         
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function when_received_without_time_or_layer_name_should_leave_default_values() : void
      {
         Expect.call(MCHAT.receivePrivateMessage(null))
            .ignoreArguments()
            .doAction(function(message:MChatMessage) : void
            {
               assertThat( message.time, nullValue() );
               assertThat( message.playerName, nullValue() );
            });
         mockRepository.replayAll();
         action.applyAction(new ChatCommand(ChatCommand.MESSAGE_PRIVATE, new Object(), true));
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function when_received_with_time_or_player_name_should_set_them() : void
      {
         var params:Object = {
            "stamp": "2011-03-27T23:17:45+03:00",
            "name": "mikism"
         };
         Expect.call(MCHAT.receivePrivateMessage(null))
            .ignoreArguments()
            .doAction(function(message:MChatMessage) : void
            {
               assertThat( message.time, notNullValue() );
               assertThat( message.time.time, equals (DateUtil.parseServerDTF(params.stamp).time) );
               assertThat( message.playerName, equals (params.name) );
            });
         mockRepository.replayAll();
         action.applyAction(new ChatCommand(ChatCommand.MESSAGE_PRIVATE, params, true));
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_send_message_to_the_server_and_keep_MChatMessage_instance() : void
      {
         SingletonFactory.client_internal::registerSingletonInstance
            (MessagesProcessor, mockRepository.createStrict(MessagesProcessor));
         var MSG_PROC:MessagesProcessor = MessagesProcessor.getInstance();
         
         var msg:MChatMessage = new MChatMessage();
         msg.playerId = 1;
         msg.message = "Shoot yourself into the foot!";
         
         Expect.call(MSG_PROC.sendMessage(null))
            .ignoreArguments()
            .doAction(function(rmo:ClientRMO) : void
            {
               assertThat( rmo, hasProperties ({
                  "additionalParams": msg,
                  "parameters": hasProperties ({
                     "pid": msg.playerId,
                     "msg": msg.message
                  })
               }));
            });
         
         mockRepository.replayAll();
         
         // action should not borrow or return any messages to the pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 0,
            "numIdle": 0
         }));
         
         action.applyAction(new ChatCommand(ChatCommand.MESSAGE_PRIVATE, new MessagePrivateActionParams(msg)));
         
         // action should not borrow or return any messages to the pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 0,
            "numIdle": 0
         }));
         
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_notify_MChat_of_successful_message_post() : void
      {
         var msg:MChatMessage = new MChatMessage();
         
         Expect.call(MCHAT.messageSendSuccess(msg));
         
         mockRepository.replayAll();
         
         // action should not touch message pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 0,
            "numIdle": 0
         }));
         
         action.result(new ClientRMO(null, null, msg, null, null));
         
         // action should not touch message pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 0,
            "numIdle": 0
         }));
         
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_notify_MChat_of_failed_message_post() : void
      {
         var msg:MChatMessage = new MChatMessage();
         
         Expect.call(MCHAT.messageSendFailure(msg));
         
         mockRepository.replayAll();
         
         // action should not touch message pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 0,
            "numIdle": 0
         }));
         
         action.cancel(new ClientRMO(null, null, msg, null, null));
         
         // action should not touch message pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 0,
            "numIdle": 0
         }));
         
         mockRepository.verifyAll();
      }
   }
}