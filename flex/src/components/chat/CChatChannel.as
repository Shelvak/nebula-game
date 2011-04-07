package components.chat
{
   import com.adobe.utils.StringUtil;
   
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   import flashx.textLayout.events.CompositionCompleteEvent;
   
   import models.chat.ChatConstants;
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatMessage;
   
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.RichEditableText;
   import spark.components.TextArea;
   import spark.components.TextInput;
   import spark.events.ElementExistenceEvent;
   
   import utils.ClassUtil;
   
   
   /**
    * Visual representation of a chat channel. Consists of:
    * <ul>
    *    <li>content area where all the text is</li>
    *    <li>list of members</li>
    *    <li>textbox for entering text</li>
    *    <li>button for sending a message</li>
    * </ul>
    */
   public class CChatChannel extends Group
   {
      public function CChatChannel(model:MChatChannel)
      {
         super();
         ClassUtil.checkIfParamNotNull("model", model);
         
         _model = model;
         
         minWidth = 0;
         minHeight = 0;
         mouseEnabled = false;
      }
      
      
      private var _model:MChatChannel;
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var txtContent:TextArea;
      private var lstMembers:CChatChannelMembers;
      private var inpMessage:TextInput;
      private var btnSend:Button;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         txtContent = new TextArea();
         with (txtContent)
         {
            minWidth = 0;
            minHeight = 0;
            left = 0;
            top = 0;
            bottom = 30;
            right = 220;
            editable = false;
            selectable = true;
            textFlow = _model.content.text;
            textFlow.addEventListener(
               CompositionCompleteEvent.COMPOSITION_COMPLETE,
               textFlow_compositionCompleteHandler
            );
         }
         addElement(txtContent);
         
         inpMessage = new TextInput();
         with (inpMessage)
         {
            left = 0;
            bottom = 0;
            right = 320;
            maxChars = ChatConstants.MAX_CHARS_IN_MESSAGE;
            addEventListener(KeyboardEvent.KEY_UP, inpMessage_keyUpHandler);
         }
         addElement(inpMessage);
         
         btnSend = new Button();
         with (btnSend)
         {
            width = 80;
            right = 220;
            bottom = 0;
            label = "Send";
            addEventListener(MouseEvent.CLICK, btnSend_clickHandler);
         }
         addElement(btnSend);
         
         lstMembers = new CChatChannelMembers(_model.members);
         with (lstMembers)
         {
            width = 200;
            top = 0;
            bottom = 0;
            right = 0;
         }
         addElement(lstMembers);
      }
      
      
      /* ############################### */
      /* ### CHILDREN EVENT HANDLERS ### */
      /* ############################### */
      
      
      private function textFlow_compositionCompleteHandler(event:CompositionCompleteEvent) : void
      {
         if (txtContent.scroller != null &&
             txtContent.scroller.verticalScrollBar != null)
         {
            txtContent.scroller.verticalScrollBar.value = Number.MAX_VALUE;
         }
      }
      
      
      private function inpMessage_keyUpHandler(event:KeyboardEvent) : void
      {
         if (event.keyCode == Keyboard.ENTER)
         {
            sendMessage();
         }
      }
      
      
      private function btnSend_clickHandler(event:MouseEvent) : void
      {
         sendMessage();
      }
      
      
      /* ############# */
      /* ### LOGIC ### */
      /* ############# */
      
      
      private function sendMessage() : void
      {
         // send message if it's not empty
         var message:String = StringUtil.trim(inpMessage.text);
         if (message.length > 0)
         {
//            _model.sendMessage(message);
            var msg:MChatMessage = MChatMessage(MChat.getInstance().messagePool.borrowObject());
            msg.playerId = 1;
            msg.playerName = "mikism";
            msg.time = new Date();
            msg.message = message;
            _model.messageSendSuccess(msg);
         }
         inpMessage.text = "";
      }
   }
}
