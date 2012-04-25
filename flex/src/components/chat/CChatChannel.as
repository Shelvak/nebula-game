package components.chat
{
   import com.adobe.utils.StringUtil;

   import components.base.Panel;

   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;

   import flashx.textLayout.events.CompositionCompleteEvent;

   import models.chat.ChatConstants;
   import models.chat.MChatChannel;
   import models.chat.MChatChannelPrivate;
   import models.chat.events.MChatChannelContentEvent;
   import models.chat.events.MChatChannelEvent;
   import models.player.Player;
   import models.time.events.MTimeEventEvent;

   import mx.events.PropertyChangeEvent;

   import namespaces.prop_name;

   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.RichEditableText;
   import spark.components.TextArea;
   import spark.components.TextInput;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.events.TextOperationEvent;

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
         urlFixed = true;
         model = null;
         model = oldOne;
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
               if (inpMessage != null && _model.silenced.hasOccurred) {
                  _model.userInput = inpMessage.text;
               }
               else {
                  _model.userInput = "";
               }
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
               _modelOld.members.removeEventListener(
                  MChatChannelEvent.MEMBERS_FILTER_CHANGE,
                  members_membersFilterChangeHandler, false
               );
               _modelOld.removeEventListener(
                  MChatChannelEvent.NUM_MEMBERS_CHANGE,
                  model_numMembersChangeHandler, false
               );
               _modelOld.removeEventListener(
                  MChatChannelEvent.USER_INPUT_CHANGE,
                  model_userInputChangeHandler, false
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
                  MTimeEventEvent.HAS_OCCURRED_CHANGE,
                  silenced_hasOccurredChangeHandler, false
               );
               _modelOld.silenced.removeEventListener(
                  MTimeEventEvent.OCCURS_IN_CHANGE,
                  silenced_occursInChangeHandler, false
               );
               _modelOld.player.removeEventListener(
                  PropertyChangeEvent.PROPERTY_CHANGE,
                  player_propertyChangeHandler, false
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
               _model.members.addEventListener(
                  MChatChannelEvent.MEMBERS_FILTER_CHANGE,
                  members_membersFilterChangeHandler, false, 0, true
               );
               _model.addEventListener(
                  MChatChannelEvent.NUM_MEMBERS_CHANGE,
                  model_numMembersChangeHandler, false, 0, true
               );
               _model.addEventListener(
                  MChatChannelEvent.USER_INPUT_CHANGE,
                  model_userInputChangeHandler, false, 0, true
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
                  MTimeEventEvent.HAS_OCCURRED_CHANGE,
                  silenced_hasOccurredChangeHandler, false, 0, true
               );
               _model.silenced.addEventListener(
                  MTimeEventEvent.OCCURS_IN_CHANGE,
                  silenced_occursInChangeHandler, false, 0, true
               );
               _model.player.addEventListener(
                  PropertyChangeEvent.PROPERTY_CHANGE,
                  player_propertyChangeHandler, false, 0, true
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
            inpMessage.setFocus();
            // Focus will be gained at the next frame so we also have to
            // invoke this code later.
            invokeSelectRangeCallbackLater();
            updateGrpFriendOfflineWarningContainer();
            updatePnlMembers();
            updateUserInput();
            updateInpMembersFilterText();
            enableAutoScroll();
            _forceAutoScrollAfterModelChange = true;
         }
         f_modelChanged = false;
      }

      private function invokeSelectRangeCallbackLater(): void {
         inpMessage.callLater(inpMessage_selectRangeCallback);
      }

      private function inpMessage_selectRangeCallback(): void {
         const text: String = inpMessage.text;
         if (text != null) {
            inpMessage.selectRange(text.length, text.length);
         }
      }

      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */

      [SkinPart(required="true")]
      /**
       * All messages are put here.
       */
      public var txtContent: TextArea;

      [SkinPart(required="true")]
      /**
       * List of all members in the channel.
       */
      public var lstMembers: CChatChannelMembers;

      [SkinPart(required="true")]
      /**
       * Input field for entering chat member name for filtering.
       */
      public var inpMembersFilter: TextInput;

      private function updateInpMembersFilterText(): void {
         if (inpMembersFilter != null && model != null) {
            inpMembersFilter.text = model.members.nameFilter;
         }
      }
      
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
            model != null
               && !model.isPublic
               && !MChatChannelPrivate(model).isFriendOnline;
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
            case inpMembersFilter:
               inpMembersFilter.addEventListener(
                  KeyboardEvent.KEY_UP,
                  inpMembersFilter_keyUpHandler, false, 0, true
               );
               inpMembersFilter.addEventListener(
                  TextOperationEvent.CHANGE,
                  inpMembersFilter_changeHandler, false, 0, true
               );
               updateInpMembersFilterText();
               break;

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
               inpMessage.addEventListener(
                  TextOperationEvent.CHANGE,
                  inpMessage_changeHandler, false, 0, true
               );
               updateUserInput();
               break;
            
            case btnSend:
               btnSend.label = getString("label.send");
               btnSend.addEventListener(
                  MouseEvent.CLICK, btnSend_clickHandler, false, 0, true
               );
               updateUserInput();
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
         }
      }
      
      protected override function partRemoved(partName:String, instance:Object) : void {
         super.partRemoved(partName, instance);
         switch (instance)
         {
            case inpMembersFilter:
               inpMembersFilter.removeEventListener(
                  KeyboardEvent.KEY_UP, inpMembersFilter_keyUpHandler, false
               );
               inpMembersFilter.removeEventListener(
                  TextOperationEvent.CHANGE, inpMembersFilter_changeHandler, false
               );
               break;

            case inpMessage:
               inpMessage.removeEventListener(
                  KeyboardEvent.KEY_UP, inpMessage_keyUpHandler, false
               );
               inpMessage.removeEventListener(
                  TextOperationEvent.CHANGE, inpMessage_changeHandler, false
               );
               break;
            
            case btnSend:
               btnSend.removeEventListener(
                  MouseEvent.CLICK, btnSend_clickHandler, false
               );
               break;
         }
      }
      
      /* ########################### */
      /* ### AUTOSCROLL HANDLING ### */
      /* ########################### */
      
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

      private function members_membersFilterChangeHandler(event: MChatChannelEvent): void {
         updateInpMembersFilterText();
      }

      private function model_isFriendOnlineChangeHandler(event: MChatChannelEvent): void {
         updateGrpFriendOfflineWarningContainer();
      }

      private function model_numMembersChangeHandler(event: MChatChannelEvent): void {
         updatePnlMembers();
      }

      private function model_userInputChangeHandler(event: MChatChannelEvent): void {
         if (model != null
                && inpMessage != null
                && model.userInput != inpMessage.text
                && model.silenced.hasOccurred) {
            updateInpMessageText();
            // Focus will be gained at the next frame so we also have to
            // invoke this code later.
            invokeSelectRangeCallbackLater();
         }
      }

      private function player_propertyChangeHandler(event: PropertyChangeEvent): void {
         if (event.property == Player.prop_name::trial) {
            updateUserInput();
         }
      }

      private function silenced_hasOccurredChangeHandler(event: MTimeEventEvent): void {
         updateUserInput();
      }

      private function silenced_occursInChangeHandler(event: MTimeEventEvent): void {
         updateInpMessageText();
      }

      private function updateUserInput(): void {
         if (model == null) {
            return;
         }
         if (btnSend != null) {
            btnSend.enabled = model.canSendMessages;
         }
         if (inpMessage != null) {
            inpMessage.enabled = model.canSendMessages;
            if (!model.canSendMessages
                   && focusManager.findFocusManagerComponent(inpMessage) != null) {
               focusManager.setFocus(txtContent);
            }
            updateInpMessageText();
         }
      }

      private function updateInpMessageText(): void {
         if (inpMessage != null && model != null) {
            if (model.canSendMessages) {
               inpMessage.text = model.userInput;
            }
            else {
               if (!model.silenced.hasOccurred) {
                  inpMessage.text = getString(
                     "message.silence",
                     [model.silenced.occursAtString(),
                      model.silenced.occursInString()]
                  );
               }
               else {
                  inpMessage.text = getString("message.trial");
               }
            }
         }
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */

      private function inpMembersFilter_changeHandler(event: TextOperationEvent): void {
         model.members.nameFilter = inpMembersFilter.text;
      }

      private function inpMessage_changeHandler(event: TextOperationEvent): void {
         if (model.silenced.hasOccurred) {
            model.userInput = inpMessage.text;
         }
      }

      private function inpMembersFilter_keyUpHandler(event:KeyboardEvent): void {
         if (event.keyCode == Keyboard.ESCAPE) {
            model.members.nameFilter = null;
         }
      }

      private function inpMessage_keyUpHandler(event: KeyboardEvent): void {
         if (event.keyCode == Keyboard.ENTER) {
            sendMessage();
         }
      }

      private function btnSend_clickHandler(event:MouseEvent) : void {
         sendMessage();
      }
      
      
      /* ############# */
      /* ### LOGIC ### */
      /* ############# */
      
      private function sendMessage() : void {
         if (!model.silenced.hasOccurred) {
            return;
         }
         const message: String = StringUtil.trim(inpMessage.text);
         if (message.length > 0) {
            model.sendMessage(message);
         }
         model.userInput = "";
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
