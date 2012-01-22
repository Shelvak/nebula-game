package components.chat
{
   import com.adobe.utils.StringUtil;
   
   import components.base.Panel;
   
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   import flashx.textLayout.events.CompositionCompleteEvent;
   
   import models.chat.ChatConstants;
   import models.chat.MChatChannel;
   import models.chat.MChatChannelPrivate;
   import models.chat.events.MChatChannelContentEvent;
   import models.chat.events.MChatChannelEvent;
   import models.time.events.MTimeEventEvent;

   import mx.events.PropertyChangeEvent;
   
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.RichEditableText;
   import spark.components.TextArea;
   import spark.components.TextInput;
   import spark.components.supportClasses.SkinnableComponent;

   import utils.DateUtil;

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
      public function CChatChannel() {
         super();
         minWidth = 0;
         minHeight = 0;
         mouseEnabled = false;
         setStyle("skinClass", CChatChannelSkin);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      // TODO temp fix for urls to work in chat
      public function urlBugWorkaround(e: MChatChannelEvent): void
      {
         e.target.removeEventListener(
            MChatChannelEvent.GOT_SOME_MESSAGE, urlBugWorkaround
         );
         var oldOne: MChatChannel = _model;
         model = null;
         model = oldOne;
         urlFixed = true;
      }

      private var urlFixed: Boolean = false;
      
      private var _modelOld:MChatChannel;
      private var _model:MChatChannel;
      public function set model(value: MChatChannel): void {
         if (_model != value) {
            if (_model != null) {
               _model.removeEventListener(
                  MChatChannelEvent.GOT_SOME_MESSAGE, urlBugWorkaround
               );
            }
            if (_modelOld == null) {
               _modelOld = _model;
            }
            _model = value;
            f_modelChanged = true;
            invalidateProperties();
            if (_model != null && !urlFixed) {
               _model.addEventListener(
                  MChatChannelEvent.GOT_SOME_MESSAGE, urlBugWorkaround
               );
            }
         }
      }
      /**
       * @private
       */
      public function get model() : MChatChannel {
         return _model;
      }
      
      
      private var f_modelChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_modelChanged) {
            if (_modelOld != null) {
               _modelOld.removeEventListener(
                  MChatChannelEvent.NUM_MEMBERS_CHANGE,
                  model_numMembersChangeHandler, false
               );
               _modelOld.content.removeEventListener(
                  MChatChannelContentEvent.MESSAGE_REMOVE,
                  modelContent_messageRemoveHandler, false
               );
               _modelOld.content.text.removeEventListener(
                  CompositionCompleteEvent.COMPOSITION_COMPLETE,
                  textFlow_compositionCompleteHandler, false
               );
               _modelOld.silenced.removeEventListener(
                  MTimeEventEvent.HAS_OCCURED_CHANGE,
                  silenced_hasOccurredChangeHandler, false
               );
               _modelOld.silenced.removeEventListener(
                  MTimeEventEvent.OCCURES_IN_CHANGE,
                  silenced_occursInChangeHandler, false
               );
               txtContent.textFlow = null;
               if (!_modelOld.isPublic) {
                  MChatChannelPrivate(_modelOld).removeEventListener(
                     MChatChannelEvent.IS_FRIEND_ONLINE_CHANGE,
                     model_isFriendOnlineChangeHandler, false
                  );
               }
               _modelOld = null;
            }
            if (_model != null) {
               _model.addEventListener(
                  MChatChannelEvent.NUM_MEMBERS_CHANGE,
                  model_numMembersChangeHandler, false, 0, true
               );
               _model.content.addEventListener(
                  MChatChannelContentEvent.MESSAGE_REMOVE,
                  modelContent_messageRemoveHandler, false, 0, true
               );
               _model.content.text.addEventListener(
                  CompositionCompleteEvent.COMPOSITION_COMPLETE,
                  textFlow_compositionCompleteHandler, false, 0, true
               );
               _model.silenced.addEventListener(
                  MTimeEventEvent.HAS_OCCURED_CHANGE,
                  silenced_hasOccurredChangeHandler, false, 0, true
               );
               _model.silenced.addEventListener(
                  MTimeEventEvent.OCCURES_IN_CHANGE,
                  silenced_occursInChangeHandler, false, 0, true
               );
               txtContent.textFlow = _model.content.text;
               lstMembers.model = _model.members;
               lstMembers.itemRendererFunction = _model.membersListIRFactory;
               if (!_model.isPublic) {
                  MChatChannelPrivate(_model).addEventListener(
                     MChatChannelEvent.IS_FRIEND_ONLINE_CHANGE,
                     model_isFriendOnlineChangeHandler, false, 0, true
                  );
               }
            }
            else {
               lstMembers.model = null;
               lstMembers.itemRendererFunction = null;
            }
            inpMessage.text = "";
            inpMessage.setFocus();
            updateGrpFriendOfflineWarningContainer();
            updatePnlMembers();
            updateGrpJoinLeaveMsgsCheckBoxContainer();
            updateChkJoinLeaveMsgs();
            enableAutoScroll();
            _forceAutoScrollAfterModelChange = true;
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
       * Panel that holds a list of all members in the channel.
       */      
      public var pnlMembers:Panel;
      private function updatePnlMembers() : void {
         if (pnlMembers != null && model != null) {
            pnlMembers.title =
               getString("label.channelMembers") + (model.numMembersVisible ? " (" + model.numMembers + ")" : "");
         }
      }
      
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
      
      [SkinPart(required="true")]
      /**
       * Container for <code>lblFriendOfflineWarning</code> and corresponding artwork.
       */
      public var grpFriendOfflineWarningContainer:Group;
      private function updateGrpFriendOfflineWarningContainer() : void {
         grpFriendOfflineWarningContainer.visible =
         grpFriendOfflineWarningContainer.includeInLayout =
            _model != null && !_model.isPublic && !MChatChannelPrivate(_model).isFriendOnline;
      }
      
      [SkinPart(required="true")]
      /**
       * Lets user decide if he wants to see member join / leave messages.
       */
      public var chkJoinLeaveMsgs:CheckBox;
      private function updateChkJoinLeaveMsgs() : void {
         if (chkJoinLeaveMsgs != null && _model != null)
            chkJoinLeaveMsgs.selected = _model.generateJoinLeaveMsgs;
      }
      
      [SkinPart(required="true")]
      /**
       * Container for <code>chkJoinLeaveMsgs</code> and corresponding artwork.
       */
      public var grpJoinLeaveMsgsCheckBoxContainer:Group;
      private function updateGrpJoinLeaveMsgsCheckBoxContainer() : void {
         if (grpJoinLeaveMsgsCheckBoxContainer != null) {
            grpJoinLeaveMsgsCheckBoxContainer.visible =
            grpJoinLeaveMsgsCheckBoxContainer.includeInLayout =
               _model != null && _model.isPublic
         }
      }
      
      [SkinPart(required="true")]
      /**
       * A warning that a friend in a private channel is offline.
       */
      public var lblFriendOfflineWarning:Label;
      
      
      protected override function partAdded(partName:String, instance:Object) : void {
         super.partAdded(partName, instance);
         switch (instance)
         {
            case txtContent:
               _lineHeight = txtContent.getStyle("fontSize") + 10;
               txtContent.setStyle("lineHeight", _lineHeight);
               txtContent.editable = false;
               txtContent.selectable = true;
               txtContent.textDisplay.addEventListener(
                  PropertyChangeEvent.PROPERTY_CHANGE,
                  textDisplay_propertyChangeHandler, false, 0, true
               );
               break;
            
            case inpMessage:
               inpMessage.maxChars = ChatConstants.MAX_CHARS_IN_MESSAGE;
               inpMessage.addEventListener(
                  KeyboardEvent.KEY_UP, inpMessage_keyUpHandler, false, 0, true
               );
               updateMessageSendingAvailability();
               break;
            
            case btnSend:
               btnSend.label = getString("label.send");
               btnSend.addEventListener(
                  MouseEvent.CLICK, btnSend_clickHandler, false, 0, true
               );
               updateMessageSendingAvailability();
               break;
            
            case lblFriendOfflineWarning:
               lblFriendOfflineWarning.text = getString("message.friendOffline");
               break;
            
            case grpFriendOfflineWarningContainer:
               updateGrpFriendOfflineWarningContainer();
               break;
            
            case pnlMembers:
               updatePnlMembers();
               break;
            
            case chkJoinLeaveMsgs:
               chkJoinLeaveMsgs.addEventListener(
                  Event.CHANGE, chkJoinLeaveMsgs_changeHandler, false, 0, true
               );
               chkJoinLeaveMsgs.label = getString("label.generateJoinLeaveMsgs");
               updateChkJoinLeaveMsgs();
               break;
            
            case grpJoinLeaveMsgsCheckBoxContainer:
               updateGrpJoinLeaveMsgsCheckBoxContainer();
               break;
         }
      }
      
      protected override function partRemoved(partName:String, instance:Object) : void {
         super.partRemoved(partName, instance);
         switch (instance)
         {
            case inpMessage:
               inpMessage.removeEventListener(
                  KeyboardEvent.KEY_UP, inpMessage_keyUpHandler, false
               );
               break;
            
            case btnSend:
               btnSend.removeEventListener(
                  MouseEvent.CLICK, btnSend_clickHandler, false
               );
               break;
            
            case chkJoinLeaveMsgs:
               chkJoinLeaveMsgs.removeEventListener(
                  Event.CHANGE, chkJoinLeaveMsgs_changeHandler, false
               );
               break;
         }
      }
      
      /* ############################ */
      /* ### AUTOSCROLL HANNDLING ### */
      /* ############################ */
      
      private static const AUTO_SCROLL_TOLERANCE:int = 50;
      private var _autoScrollOn:Boolean = true;
      private var _anchoredScrollPosition:Number = 0;
      private var _messagesRemoved:int = 0;
      private var _lineHeight:Number = 0;
      private var _forceAutoScrollAfterModelChange:Boolean = true;
      
      private function enableAutoScroll() : void {
         _autoScrollOn = true;
         _anchoredScrollPosition = 0;
         _messagesRemoved = 0;
      }
      
      private function textDisplay_propertyChangeHandler(event:PropertyChangeEvent) : void {
         if (event.property != "verticalScrollPosition")
            return;
         
         var textDisplay:RichEditableText = RichEditableText(event.target);
         _autoScrollOn = _forceAutoScrollAfterModelChange
                            || Math.abs(textDisplay.contentHeight
                                           - textDisplay.verticalScrollPosition
                                           - textDisplay.height)
                                  < AUTO_SCROLL_TOLERANCE;
         if (_autoScrollOn) {
            _anchoredScrollPosition = 0;
            _messagesRemoved = 0;
         }
         else
            _anchoredScrollPosition = textDisplay.verticalScrollPosition;
         if (_forceAutoScrollAfterModelChange) {
            _forceAutoScrollAfterModelChange = false;
            scrollToBottom();
         }
      }
      
      private function textFlow_compositionCompleteHandler(event:CompositionCompleteEvent) : void {
         if (_autoScrollOn)
            scrollToBottom();
         else if (_anchoredScrollPosition > 0) {
            if (_messagesRemoved > 0) {
               _messagesRemoved--;
               _anchoredScrollPosition -= _lineHeight;
               if (_anchoredScrollPosition > 0)
                  scrollTo(_anchoredScrollPosition);
            }
         }
         else
            _messagesRemoved = 0;
      }
      
      private function modelContent_messageRemoveHandler(event:MChatChannelContentEvent) : void {
         if (!_autoScrollOn)
            _messagesRemoved++;
      }
      
      private function scrollToBottom() : void {
         scrollTo(Number.MAX_VALUE);
      }
      
      private function scrollTo(verticalPosition:Number) : void {
         txtContent.scroller.verticalScrollBar.value = verticalPosition;
      }
      
      private function verticalScrollPosition() : Number {
         return txtContent.scroller.verticalScrollBar.value;
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */

      private function model_isFriendOnlineChangeHandler(event: MChatChannelEvent): void {
         updateGrpFriendOfflineWarningContainer();
      }

      private function model_numMembersChangeHandler(event: MChatChannelEvent): void {
         updatePnlMembers();
      }

      private function silenced_hasOccurredChangeHandler(event: MTimeEventEvent): void {
         updateMessageSendingAvailability();
      }

      private function silenced_occursInChangeHandler(event: MTimeEventEvent): void {
         updateInpMessageText();
      }

      private function updateMessageSendingAvailability(): void {
         if (_model == null) {
            return;
         }
         if (btnSend != null) {
            btnSend.enabled = _model.silenced.hasOccured;
         }
         if (inpMessage != null) {
            inpMessage.enabled = _model.silenced.hasOccured;
            updateInpMessageText();
         }
      }

      private function updateInpMessageText(): void {
         if (inpMessage != null && _model != null) {
            if (_model.silenced.hasOccured) {
               inpMessage.text = "";
            }
            else {
               inpMessage.text = getString(
                  "message.silence",
                  [DateUtil.formatShortDateTime(_model.silenced.occuresAt),
                   _model.silenced.occuresInString]
               );
            }
         }
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      private function inpMessage_keyUpHandler(event:KeyboardEvent) : void {
         if (event.keyCode == Keyboard.ENTER) {
            sendMessage();
         }
      }
      
      private function btnSend_clickHandler(event:MouseEvent) : void {
         sendMessage();
      }
      
      private function chkJoinLeaveMsgs_changeHandler(event:Event) : void {
         if (_model != null) {
            _model.generateJoinLeaveMsgs = chkJoinLeaveMsgs.selected;
         }
      }
      
      
      /* ############# */
      /* ### LOGIC ### */
      /* ############# */
      
      private function sendMessage() : void {
         if (!model.silenced.hasOccured) {
            return;
         }
         var message:String = StringUtil.trim(inpMessage.text);
         if (message.length > 0) {
            _model.sendMessage(message);
         }
         inpMessage.text = "";
         enableAutoScroll();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function getString(property:String, parameters:Array = null) : String {
         return Localizer.string("Chat", property, parameters);
      }
   }
}
