package components.chat
{
   import com.adobe.utils.StringUtil;
   
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   import flashx.textLayout.events.CompositionCompleteEvent;
   
   import models.chat.ChatConstants;
   import models.chat.MChatChannel;
   
   import spark.components.Button;
   import spark.components.TextArea;
   import spark.components.TextInput;
   import spark.components.supportClasses.SkinnableComponent;
   
   import utils.locale.Localizer;
   
   
   /**
    * Visual representation of a chat channel. Consists of:
    * <ul>
    *    <li>content area where all the text is</li>
    *    <li>list of members</li>
    *    <li>textbox for entering text</li>
    *    <li>button for sending a message</li>
    * </ul>
    */
   public class CChatChannel extends SkinnableComponent
   {
      public function CChatChannel()
      {
         super();
         minWidth = 0;
         minHeight = 0;
         mouseEnabled = false;
         setStyle("skinClass", CChatChannelSkin);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _modelOld:MChatChannel;
      private var _model:MChatChannel;
      public function set model(value:MChatChannel) : void
      {
         if (_model != value)
         {
            if (_modelOld == null)
            {
               _modelOld = _model;
            }
            _model = value;
            f_modelChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get model() : MChatChannel
      {
         return _model;
      }
      
      
      private var f_modelChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_modelChanged)
         {
            if (_modelOld != null)
            {
               _modelOld.content.text.removeEventListener(
                  CompositionCompleteEvent.COMPOSITION_COMPLETE,
                  textFlow_compositionCompleteHandler
               );
               txtContent.textFlow = null;
            }
            if (_model != null)
            {
               _model.content.text.addEventListener(
                  CompositionCompleteEvent.COMPOSITION_COMPLETE,
                  textFlow_compositionCompleteHandler
               );
               txtContent.textFlow = _model.content.text;
               lstMembers.model = _model.members;
            }
            else
            {
               lstMembers.model = null;
            }
            inpMessage.text = "";
         }
         f_modelChanged = false;
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * All messages are put here.
       */
      public var txtContent:TextArea;
      
      
      [SkinPart(required="true")]
      /**
       * List of all members in the channel.
       */
      public var lstMembers:CChatChannelMembers;
      
      
      [SkinPart(required="true")]
      /**
       * Input field for entering messages.
       */
      public var inpMessage:TextInput;
      
      
      [SkinPart(required="true")]
      /**
       * Dumb users will use this to send their message.
       */
      public var btnSend:Button;
      
      
      protected override function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         
         switch (instance)
         {
            case txtContent:
               txtContent.editable = false;
               txtContent.selectable = true;
               break;
            
            case inpMessage:
               inpMessage.maxChars = ChatConstants.MAX_CHARS_IN_MESSAGE;
               inpMessage.addEventListener(KeyboardEvent.KEY_UP, inpMessage_keyUpHandler, false, 0, true);
               break;
            
            case btnSend:
               btnSend.label = getString("label.send");
               btnSend.addEventListener(MouseEvent.CLICK, btnSend_clickHandler, false, 0, true);
               break;
         }
      }
      
      
      protected override function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName, instance);
         
         switch (instance)
         {
            case inpMessage:
               inpMessage.removeEventListener(KeyboardEvent.KEY_UP, inpMessage_keyUpHandler, false);
               break;
            
            case btnSend:
               btnSend.removeEventListener(MouseEvent.CLICK, btnSend_clickHandler, false);
               break;
         }
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      
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
            _model.sendMessage(message);
//            var msg:MChatMessage = MChatMessage(MChat.getInstance().messagePool.borrowObject());
//            msg.playerId = 1;
//            msg.playerName = "mikism";
//            msg.time = new Date();
//            msg.message = message;
//            _model.messageSendSuccess(msg);
         }
         inpMessage.text = "";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getString(property:String, parameters:Array = null) : String
      {
         return Localizer.string("Chat", property, parameters);
      }
   }
}
