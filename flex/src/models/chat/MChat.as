package models.chat
{
   import controllers.startup.StartupInfo;
   import controllers.ui.NavigationController;

   import interfaces.IUpdatable;

   import models.BaseModel;
   import models.ModelLocator;
   import models.chat.events.IgnoredMembersEvent;
   import models.chat.events.MChatEvent;
   import models.time.MTimeEventFixedMoment;

   import mx.logging.ILogger;

   import mx.utils.ObjectUtil;

   import namespaces.client_internal;

   import utils.Objects;
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   import utils.logging.IMethodLoggerFactory;
   import utils.logging.Log;
   import utils.pool.IObjectPool;
   import utils.pool.impl.StackObjectPoolFactory;


   /**
    * @see MChatEvent#SELECTED_CHANNEL_CHANGE
    */
   [Event(name="selectedChannelChange", type="models.chat.events.MChatEvent")]
   
   /**
    * @see MChatEvent#PRIVATE_CHANNEL_OPEN_CHANGE
    */
   [Event(name="privateChannelOpenChange", type="models.chat.events.MChatEvent")]
   
   /** 
    * @see MChatEvent#ALLIANCE_CHANNEL_OPEN_CHANGE
    */
   [Event(name="allianceChannelOpenChange", type="models.chat.events.MChatEvent")]
   
   /** 
    * @see MChatEvent#HAS_UNREAD_ALLIANCE_MSG_CHANGE
    */
   [Event(name="hasUnreadAllianceMsgChange", type="models.chat.events.MChatEvent")]
   
   /** 
    * @see MChatEvent#HAS_UNREAD_PRIVATE_MSG_CHANGE
    */
   [Event(name="hasUnreadPrivateMsgChange", type="models.chat.events.MChatEvent")]
   
   /**
    * @see MChatEvent#HAS_UNREAD_MAIN_MSG_CHANGE
    */
   [Event(name="hasUnreadMainMsgChange", type="models.chat.events.MChatEvent")]
   
   /**
    * @see MChatEvent#VISIBLE_CHANGE
    */
   [Event(name="visibleChange", type="models.chat.events.MChatEvent")]
   
   /**
    * Chat singleton.
    * 
    * <p>Aggregates all channels and members of the chat.</p>
    */
   public class MChat extends BaseModel implements IUpdatable
   {
      /**
       * Name of a main public channel (galaxy).
       */
      public static const MAIN_CHANNEL_NAME:String = "galaxy";
      
      /**
       * Index of a main public channel (galaxy) in the channels list (0).
       */
      public static const MAIN_CHANNEL_INDEX:int = 0;
      
      /**
       * Prefix used for alliance channel names (alliance-). If present, alliance channel is always the
       * third in the list.
       */
      public static const ALLIANCE_CHANNEL_PREFIX:String = "alliance-";
      
      /**
       * Index of an alliance channel in the channels list (1).
       */
      public static const ALLIANCE_CHANNEL_INDEX:int = 1;
      
      
      public static function getInstance() : MChat {
         return SingletonFactory.getSingletonInstance(MChat);
      }
      
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }

      private const loggerFactory: IMethodLoggerFactory = Log.getMethodLoggerFactory(MChat);

      public function MChat() {
         _messagePool = new StackObjectPoolFactory(new MChatMessageFactory()).createPool();
         _members  = new MChatMembersList();
         _channels = new MChatChannelsList();
      }

      private var _ignoredMembers: IgnoredMembers = null;
      public function get ignoredMembers(): IgnoredMembers {
         if (_ignoredMembers == null) {
            _ignoredMembers = new IgnoredMembers();
            _ignoredMembers.addEventListener(
               IgnoredMembersEvent.REMOVE_FROM_IGNORE,
               ignoredMembers_removeFromIgnoreHandler, false, 0, true
            );
            _ignoredMembers.addEventListener(
               IgnoredMembersEvent.ADD_TO_IGNORE,
               ignoredMembers_addToIgnoreHandler, false, 0, true
            );
         }
         return _ignoredMembers;
      }

      private function ignoredMembers_addToIgnoreHandler(event: IgnoredMembersEvent): void {
         const member: MChatMember = members.getMemberByName(event.memberName);
         if (member != null) {
            member.isIgnored = true;
         }
      }

      private function ignoredMembers_removeFromIgnoreHandler(event: IgnoredMembersEvent): void {
         const member: MChatMember = members.getMemberByName(event.memberName);
         if (member != null) {
            member.isIgnored = false;
         }
      }

      private function isCompleteIgnored(memberName: String): Boolean {
         return ignoredMembers.isCompleteIgnored(memberName);
      }

      private function isFilteredIgnored(memberName: String): Boolean {
         return ignoredMembers.isFilteredIgnored(memberName);
      }

      private function filterMessage(message:MChatMessage): void {
         if (isFilteredIgnored(message.playerName)) {
            message.message = getString("message.memberIgnored");
         }
      }

      private var _messagePool: IObjectPool = null;
      /**
       * Returns <code>MChatMessage</code> pool for the chat.
       */
      public function get messagePool() : IObjectPool {
         return _messagePool;
      }

      private const _silenced: MTimeEventFixedMoment =
                       new MTimeEventFixedMoment();
      public function get silenced(): MTimeEventFixedMoment {
         return _silenced;
      }

      
      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public function update(): void {
         _silenced.update();
      }

      public function resetChangeFlags(): void {
         _silenced.resetChangeFlags();
      }
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */

      private var _jsCallbacksInvoker: IChatJSCallbacksInvoker;

      client_internal var _initialized: Boolean = false;
      private function get initialized(): Boolean {
         return client_internal::_initialized;
      }
      
      /**
       * Initializes the chat:
       * <ul>
       *    <li>creates the list of chat members from members hash</li>
       *    <li>creates the list of channels from channels hash</li>
       *    <li>adds chat members to one or more appropriate channels</li>
       * <ul> 
       * 
       * @param members chat members (players) hash (see <code>controllers.chat.actions.IndexAction</code>)
       * @param channels chat channels hash (see <code>controllers.chat.actions.IndexAction</code>)
       * 
       * @see controllers.chat.actions.IndexAction
       */
      public function initialize(jsCallbacksInvoker: IChatJSCallbacksInvoker,
                                 members: Object,
                                 channels: Object): void {
         _jsCallbacksInvoker = jsCallbacksInvoker;
         for (var chatMemberId: String in members) {
            const memberId: int = int(chatMemberId);
            const memberName: String = members[chatMemberId];
            _members.addMember(new MChatMember(
               memberId, memberName, true, ignoredMembers.isIgnored(memberName)
            ));
         }

         var channel: MChatChannelPublic;

         for (var channelName: String in channels) {
            channel = new MChatChannelPublic(channelName);
            channel.generateJoinLeaveMsgs = _generateJoinLeaveMsgs;
            addMembersToChannel(channel, channels[channelName]);
            _channels.addChannel(channel);
            if (channel.isAlliance) {
               setAllianceChannelOpen(true);
            }
         }

         // main channel must be first in the list
         channel = MChatChannelPublic(_channels.getChannel(MAIN_CHANNEL_NAME));
         if (channel == null) {
            throw new Error(
               "Unable to initialize chat: main channel '" + MAIN_CHANNEL_NAME
                  + "' not found in channels list \n"
                  + ObjectUtil.toString(channels)
            );
         }
         _channels.moveChannel(channel.name, MAIN_CHANNEL_INDEX);

         // alliance channel should go second in the list, if present
         channel = Collections.findFirst(
            _channels,
            function (chan: MChatChannel): Boolean {
               return chan.isPublic && MChatChannelPublic(chan).isAlliance;
            }
         );
         if (channel != null) {
            _channels.moveChannel(channel.name, ALLIANCE_CHANNEL_INDEX);
         }

         selectChannel(MChatChannel(_channels.getItemAt(0)).name);

         client_internal::_initialized = true;
      }
      
      
      private function addMembersToChannel(channel:MChatChannel, memberIds:Array) : void
      {
         for each (var id:int in memberIds)
            channel.memberJoin(_members.getMember(id), false);
      }
      
      
      /**
       * Invoked when application must be reset (after disconnect or some similar problem): resets
       * the chat to its initial state before initialization.
       */
      public function reset() : void
      {
         _messagePool = new StackObjectPoolFactory(new MChatMessageFactory()).createPool();
         _channels.reset();
         _members.reset();
         _visible = false;
         _selectedChannel = null;
         _recentPrivateChannel = null;
         client_internal::_initialized = false;
         
         // need events for these
         setAllianceChannelOpen(false);
         setPrivateChannelOpen(false);
         setHasUnreadMainMsg(false);
         updateNumPrivateMessages();
         updateNumUnreadAllianceMessages();
      }
      
      
      /* ########## */
      /* ### UI ### */
      /* ########## */
      
      
      private var _hasUnreadMainMsg:Boolean = false;
      /**
       * <code>true</code> if there is at least one unread message in main channel. When this property
       * changes, <code>MChatEvent.HAS_UNREAD_MAIN_MSG_CHANGE</code> event is dispatched.
       * 
       * <p>No property change event.</p>
       */
      public function get hasUnreadMainMsg() : Boolean {
         return _hasUnreadMainMsg;
      }
      private function setHasUnreadMainMsg(value:Boolean) : void {
         if (_hasUnreadMainMsg != value) {
            _hasUnreadMainMsg = value;
            dispatchChatEvent(MChatEvent.HAS_UNREAD_MAIN_MSG_CHANGE);
         }
      }
      
      
      /**
       * <code>true</code> if there is at least one unread message in alliance
       * channel, if there is one open. When this property changes,
       * <code>MChatEvent.HAS_UNREAD_ALLIANCE_MSG_CHANGE</code> event
       * is dispatched.
       */
      public function get hasUnreadAllianceMsg() : Boolean {
         return numUnreadAllianceMessages > 0;
      }

      private var _numUnreadAllianceMessages: int = 0;
      /**
       * Number of unread messages in alliance channel.
       */
      public function get numUnreadAllianceMessages(): int {
         return _numUnreadAllianceMessages;
      }
      private function updateNumUnreadAllianceMessages(): void {
         var numMessages: int = 0;
         if (allianceChannelOpen) {
            for each (var chan: MChatChannel in _channels) {
               if (chan.isPublic && MChatChannelPublic(chan).isAlliance) {
                  numMessages = chan.numUnreadMessages;
               }
            }
         }
         if (_numUnreadAllianceMessages != numMessages) {
            const hasUnreadAllianceMsgOld: Boolean = hasUnreadAllianceMsg;
            _numUnreadAllianceMessages = numMessages;
            if (hasUnreadAllianceMsg != hasUnreadAllianceMsgOld) {
               dispatchChatEvent(MChatEvent.HAS_UNREAD_ALLIANCE_MSG_CHANGE);
            }
            if (_jsCallbacksInvoker != null) {
               if (numMessages > 0) {
                  _jsCallbacksInvoker.hasUnreadAllianceMessages(
                     getString("js.title.allianceMessages", [numMessages])
                  );
               }
               else {
                  _jsCallbacksInvoker.allianceMessagesRead();
               }
            }
         }
      }

      /**
       * <code>true</code> if there is at least one unread message in any of private channels, if there are
       * any open. When this property changes, <code>MChatEvent.HAS_UNREAD_PRIVATE_MSG_CHANGE</code> event
       * is dispatched.
       * 
       * <p>No property change event.</p>
       */
      public function get hasUnreadPrivateMsg() : Boolean {
         return numUnreadPrivateMessages > 0;
      }

      private var _numUnreadPrivateMessages: int = 0;
      /**
       * Number of unread private messages.
       */
      public function get numUnreadPrivateMessages(): int {
         return _numUnreadPrivateMessages;
      }
      private function updateNumPrivateMessages(): void {
         var numMessages: int = 0;
         for each (var chan: MChatChannel in _channels) {
            if (!chan.isPublic) {
               numMessages += chan.numUnreadMessages;
            }
         }
         if (_numUnreadPrivateMessages != numMessages) {
            const oldHasUnreadPrivateMsg: Boolean = hasUnreadPrivateMsg;
            _numUnreadPrivateMessages = numMessages;
            if (oldHasUnreadPrivateMsg != hasUnreadPrivateMsg) {
               dispatchChatEvent(MChatEvent.HAS_UNREAD_PRIVATE_MSG_CHANGE);
            }
            if (_jsCallbacksInvoker != null) {
               if (numMessages > 0) {
                  _jsCallbacksInvoker.hasUnreadPrivateMessages(
                     getString("js.title.privateMessages", [numMessages])
                  );
               }
               else {
                  _jsCallbacksInvoker.privateMessagesRead();
               }
            }
         }
      }
      
      
      /**
       * Selects a channel with given name if it is not yet selected.
       * 
       * @param channelName name of a channel to select.
       *                    <b>Not null. Not empty string.</b>
       */
      public function selectChannel(channelName:String) : void {
         Objects.paramNotEquals("channelName", channelName, [null, ""]);

         var toSelect: MChatChannel = _channels.getChannel(channelName);
         if (toSelect == null) {
            throwChannelNotFoundError("Unable to select channel", channelName);
         }
         if (_selectedChannel == toSelect) {
            return;
         }
         if (_visible) {
            if (_selectedChannel != null) {
               _selectedChannel.visible = false;
            }
            toSelect.visible = true;
            if (toSelect.isPublic) {
               if (MChatChannelPublic(toSelect).isAlliance) {
                  updateNumUnreadAllianceMessages();
               }
               else {
                  setHasUnreadMainMsg(toSelect.hasUnreadMessages);
               }
            }
            else {
               updateNumPrivateMessages();
            }
         }
         _selectedChannel = toSelect;
         if (!toSelect.isPublic)
            _recentPrivateChannel = toSelect;
         dispatchChatEvent(MChatEvent.SELECTED_CHANNEL_CHANGE);
      }
      
      
      private var _selectedChannel:MChatChannel;
      /**
       * Channel at the moment observed by the player.
       */
      public function get selectedChannel() : MChatChannel
      {
         return _selectedChannel;
      }
      
      
      private var _visible:Boolean = false;
      /**
       * Indicates if player is looking at the chat screen right now.
       */
      public function set visible(value:Boolean) : void {
         if (_visible != value) {
            _visible = value;
            if (selectedChannel != null) {
               selectedChannel.visible = value;
               if (_visible) {
                  if (selectedChannel.isPublic) {
                     if (MChatChannelPublic(selectedChannel).isAlliance) {
                        updateNumUnreadAllianceMessages();
                     }
                     else {
                        setHasUnreadMainMsg(false);
                     }
                  }
                  else {
                     updateNumPrivateMessages();
                  }
               }
            }
            dispatchChatEvent(MChatEvent.VISIBLE_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get visible() : Boolean {
         return _visible;
      }
      
      
      /**
       * Called when chat screen is switched and shown for the player.
       */
      public function screenShowHandler() : void {
         visible = true;
      }
      
      
      /**
       * Called when chat screen is hidden and not shown to the player.
       */
      public function screenHideHandler() : void {
         visible = false;
      }
      
      
      /**
       * Selects main channel if it is not currently selected.
       */
      public function selectMainChannel() : void {
         selectChannel(MAIN_CHANNEL_NAME);
      }
      
      
      /**
       * Selects alliance channel if there is one and it is not currently selected.
       */
      public function selectAllianceChannel() : void {
         for each (var channel: MChatChannel in _channels) {
            if (channel.isPublic && MChatChannelPublic(channel).isAlliance) {
               selectChannel(channel.name);
            }
         }
      }
      
      // this one is changed in selectChannel() and closePrivateChannel()
      private var _recentPrivateChannel: MChatChannel = null;
      /**
       * Selects most recently opened private channel. If there is no such channel, selects the first private
       * channel. If there is no private channel opened at all, does nothing.
       */
      public function selectRecentPrivateChannel() : void {
         var firstPrivateChannel:MChatChannel = null;
         var numPrivateChannels:int = 0;
         for each (var channel:MChatChannel in _channels) {
            if (!channel.isPublic) {
               if (numPrivateChannels == 0)
                  firstPrivateChannel = channel;
               numPrivateChannels++;
               if (numPrivateChannels == 2)
                  break;
            }
         }
         if (numPrivateChannels == 1)
            selectChannel(channel.name);
         else if (numPrivateChannels > 1) {
            if (_recentPrivateChannel != null)
               selectChannel(_recentPrivateChannel.name);
            else
               selectChannel(firstPrivateChannel.name);
         }
      }
      
      
      /* ############### */
      /* ### MEMBERS ### */
      /* ############### */
      
      
      private var _members:MChatMembersList;
      /**
       * Lits of all chat members.
       */
      public function get members() : MChatMembersList {
         return _members;
      }

      /**
       * Changes the name of a chat member if one can be found.
       */
      public function renameMember(id: int, newName: String): void {
         if (members.containsMember(id)) {
            members.getMember(id).name = newName;
         }
      }
      
      
      /**
       * Function for comparing two <code>MChatMember</code>s. 
       * 
       * @see mx.collections.Sort#compareFunction
       */
      public static function compareFunction_members(m1: MChatMember,
                                                     m2: MChatMember,
                                                     fields: Array = null) : int {
         var compareResult:int = ObjectUtil.stringCompare(m1.name, m2.name, true);
         if (compareResult != 0) {
            return compareResult;
         }
         return ObjectUtil.numericCompare(m1.id, m2.id);
      }
      
      
      /**
       * Called when a player has joined a chat channel.
       * 
       * @param channelName name of the channel.
       *        <b>Not null</b>.
       * @param member a member who has joined the channel.
       */
      public function channelJoin(channelName: String,
                                  member: MChatMember): void {
         Objects.paramNotNull("channelName", channelName);

         // Server sometimes sends chat|join messages before chat|index.
         // So when chat|index hits the processor, initialize() tries to create channels that
         // already exist.
         if (!initialized && StartupInfo.relaxedServerMessagesHandlingMode) {
            return;
         }

         var existingMember: MChatMember = _members.getMember(member.id);
         if (existingMember == null) {
            _members.addMember(member);
            existingMember = member;
         }

         var channel: MChatChannelPublic =
                MChatChannelPublic(_channels.getChannel(channelName));
         if (channel == null) {
            channel = createPublicChannel(channelName);
         }
         if (!channel.members.containsMember(existingMember.id)) {
            channel.memberJoin(existingMember);
         }

         existingMember.isOnline = true;
      }
      
      
      /**
       * Called when a player has left a chat channel.
       * 
       * @param channelName name of the channel.
       *        <b>Not null</b>.
       * @param memberId id of a chat channel member who has left the channel
       */
      public function channelLeave(channelName: String, memberId: int): void {
         Objects.paramNotNull("channelName", channelName);

         const channel: MChatChannelPublic =
                  MChatChannelPublic(_channels.getChannel(channelName));
         if (channel == null) {
            return;
         }

         const member: MChatMember = _members.getMember(memberId);
         if (member == null) {
            return;
         }
         
         channel.memberLeave(member);
         
         // remove the channel if it is an alliance channel and current player has left the channel
         if (channel.isAlliance && member.id == ML.player.id) {
            removeChannel(channel);
            setAllianceChannelOpen(false);
         }
         
         // make member to be offline if it is not in any of public channels
         var isOnline: Boolean = false;
         for each (var chan: MChatChannel in _channels) {
            if (chan.isPublic && chan.members.containsMember(member.id)) {
               isOnline = true;
               break;
            }
         }
         member.isOnline = isOnline;
         
         removeMemberIfNotInChannel(memberId);
      }

      /**
       * Finds <code>MChatMember</code> instance representing current player and returns it.
       */
      private function get player(): MChatMember {
         return _members.getMember(ML.player.id);
      }

      /**
       * Removes a member with a given id from the members list if it can't be found in any of open channels.
       */
      private function removeMemberIfNotInChannel(memberId: int): void {
         for each (var chan: MChatChannel in _channels) {
            if (chan.members.containsMember(memberId)) {
               return;
            }
         }
         const member: MChatMember = _members.getMember(memberId);
         if (member != null) {
            // remove member if it is actually in the list
            _members.removeMember(member);
         }
      }
      
      
      /* ################ */
      /* ### CHANNELS ### */
      /* ################ */

      private var _generateJoinLeaveMsgs: Boolean = false;
      /**
       * Should join/leave channel system messages be generated?
       */
      public function set generateJoinLeaveMsgs(value: Boolean): void {
         if (_generateJoinLeaveMsgs != value) {
            _generateJoinLeaveMsgs = value;
            for each (var channel:MChatChannel in _channels) {
               channel.generateJoinLeaveMsgs = _generateJoinLeaveMsgs;
            }
         }
      }
      
      
      private var _channels:MChatChannelsList;
      /**
       * List of all channels currently open.
       */
      public function get channels() : MChatChannelsList
      {
         return _channels;
      }
      
      
      /**
       * Creates new public channel with a given name, adds it to channels list and returns it.
       * 
       * @param name name of the new public channel.
       * 
       * @return newly created <code>MChatChannelPublic</code>.
       */
      private function createPublicChannel(name:String) : MChatChannelPublic
      {
         const channel:MChatChannelPublic = new MChatChannelPublic(name);
         channel.generateJoinLeaveMsgs = _generateJoinLeaveMsgs;
         _channels.addChannel(channel);
         if (channel.isAlliance)
         {
            _channels.moveChannel(channel.name, ALLIANCE_CHANNEL_INDEX);
            setAllianceChannelOpen(true);
         }
         return channel;
      }
      
      
      /**
       * Creates new private channel with between current player and given member, adds it to channels list
       * and returns it. Both <code>MChatMember</code> instances - the one representing current player and
       * <code>member</code> - are added to the newly created channel.
       * 
       * @param member <code>MChatMember</code> representing different player than the current to create
       *               channel to. 
       * 
       * @return newly created <code>MChatChannelPrivate</code>.
       */
      private function createPrivateChannel(member:MChatMember) : MChatChannelPrivate
      {
         var channel:MChatChannelPrivate = new MChatChannelPrivate(member.name);
         channel.generateJoinLeaveMsgs = _generateJoinLeaveMsgs;
         channel.memberJoin(player, false);
         channel.memberJoin(member, false);
         _channels.addChannel(channel);
         updatePrivateChannelOpen();
         return channel;
      }
      
      
      /**
       * Creates new private channel for communication between current player and the given member and
       * selects it. Shows chat screen if it is not visible. Any further calls with the same member ID while
       * the channel is open will cause the channel to be selected if it is not yet selected. Does nothing
       * and immediately returns if you pass id of a current player.
       * 
       * @param memberId id of a member to open private channel to.
       * @param memberName name of a member to open private channel to. You need to provide this only if
       * this mnember is not present in any of public channels (is offline).
       */
      public function openPrivateChannel(memberId: int,
                                         memberName: String = null): void {
         var member: MChatMember = members.getMember(memberId);
         if (member == null) {
            if (memberName == null) {
               throw new ArgumentError(
                  "Unable to open private channel: member with id " + memberId + " not found and " +
                     "[param memberName] was null"
               );
            }
            // ignore players that are in ignore list
            if (isCompleteIgnored(memberName)) {
               return;
            }
            member = new MChatMember(memberId, memberName);
            members.addMember(member);
         }

         // ignore self lovers and ignored players
         if (member == player || isCompleteIgnored(member.name)) {
            return;
         }
         
         // if we have private channel open already, just select it
         if (_channels.containsChannel(member.name))
         {
            selectChannel(member.name);
            NAV_CTRL.showChat();
            return;
         }
         
         createPrivateChannel(member);
         selectChannel(member.name);
         NAV_CTRL.showChat();
      }
      
      
      /**
       * Removes private channel with a given name from the channels list.
       * 
       * @param channelName name of an open private channel to remove (close).
       *                    <b>Not null. Not empty string.</b>
       */
      public function closePrivateChannel(channelName: String): void {
         Objects.paramNotEquals("channelName", channelName, [null, ""]);

         var channel: MChatChannel = _channels.getChannel(channelName);
         if (channel == null) {
            // Not a critical error here I suppose.
            loggerFactory.getLogger("closePrivateChannel").warn(
               "unable to find channel with name '{0}'. Returning.", channelName);
            return;
         }
         if (channel.isPublic) {
            // Nothing serious here. Just ignore the call.
            return;
         }

         if (_recentPrivateChannel == channel) {
            _recentPrivateChannel = null;
         }
         removeChannel(channel);
         
         const privateChan:MChatChannelPrivate = MChatChannelPrivate(channel);
         removeMemberIfNotInChannel(privateChan.friend.id);
         privateChan.cleanup();
         
         updatePrivateChannelOpen();
         updateNumPrivateMessages();
      }
      
      
      /**
       * Removes given channel from channels list.
       * 
       * @param channel channel to remove (close).
       *                <b>Not null.</b>
       */
      private function removeChannel(channel: MChatChannel): void {
         Objects.paramNotNull("channel", channel);

         var removeIndex: int = _channels.getItemIndex(channel);
         _channels.removeChannel(channel);

         if (_selectedChannel == channel) {
            // select next channel when selected channel was closed
            if (removeIndex == _channels.length) {
               // or the previous channel if the last channel was selected
               removeIndex--;
            }
            selectChannel(MChatChannel(_channels.getItemAt(removeIndex)).name);
         }
      }
      
      
      private var _privateChannelOpen:Boolean = false;
      /**
       * Returns <code>true</code> if there is at least one private channel open. When this property
       * changes <code>MChatEvent.HAS_PRIVATE_CHANNGEL_CHANGE</code> event is dispatched.
       * 
       * <p>No property change event.</p>
       */
      public function get privateChannelOpen() : Boolean {
         return _privateChannelOpen;
      }
      private function updatePrivateChannelOpen() : void {
         var hasPrivateChannel:Boolean = false;
         for each (var channel:MChatChannel in channels) {
            if (!channel.isPublic) {
               hasPrivateChannel = true;
               break;
            }
         }
         setPrivateChannelOpen(hasPrivateChannel);
      }
      private function setPrivateChannelOpen(value:Boolean) : void {
         if (_privateChannelOpen != value) {
            _privateChannelOpen = value;
            dispatchChatEvent(MChatEvent.PRIVATE_CHANNEL_OPEN_CHANGE);
         }
      }
      
      
      private var _allianceChannelOpen:Boolean = false;
      /**
       * Returns <code>true</code> if there is alliance channel open. When this property
       * changes <code>MChatEvent.HAS_ALLIANCE_CHANNGEL_CHANGE</code> event is dispatched.
       * 
       * <p>No property change event.</p>
       */
      public function get allianceChannelOpen() : Boolean {
         return _allianceChannelOpen;
      }
      private function setAllianceChannelOpen(value: Boolean): void
      {
         if (_allianceChannelOpen != value) {
            _allianceChannelOpen = value;
            if (!_allianceChannelOpen) {
               updateNumUnreadAllianceMessages();
            }
            dispatchChatEvent(MChatEvent.ALLIANCE_CHANNEL_OPEN_CHANGE);
         }
      }
      
      
      /* ############################### */
      /* ### PUBLIC CHANNEL MESSAGES ### */
      /* ############################### */

      /**
       * Called when a message to a public channel has been sent by some chat member.
       * 
       * @param message instance of <code>MChatMessage</code> that represents the message received. Must
       *                have been borrowed from <code>messagePool</code>. Don't return it to the pool in the
       *                <code>MessagePublicAction</code>: it will be returned by the
       *                <code>MChatChannelContent</code>.
       *                <b>Not null.</b>
       */
      public function receivePublicMessage(message: MChatMessage): void {
         Objects.paramNotNull("message", message);

         const logger: ILogger = loggerFactory.getLogger("receivePublicMessage");
         const channel: MChatChannelPublic =
                MChatChannelPublic(_channels.getChannel(message.channel));
         if (channel == null) {
            logger.warn(
               "Unable to process message {0}: channel {1} not found! Ignoring.",
               message, message.channel
            );
            return;
         }

         const member: MChatMember = _members.getMember(message.playerId);
         if (member == null) {
            logger.warn(
               "Unable to process message {0}: member with id {1} not found! Ignoring.",
               message, message.playerId
            );
            return;
         }

         message.playerName = member.name;
         message.time = new Date();

         if (isCompleteIgnored(member.name)) {
            return;
         }
         filterMessage(message);

         channel.receiveMessage(message);

         if (channel.isAlliance) {
            updateNumUnreadAllianceMessages();
         }
         else {
            setHasUnreadMainMsg(channel.hasUnreadMessages);
         }
      }
      
      
      /* ################################ */
      /* ### PRIVATE CHANNEL MESSAGES ### */
      /* ################################ */

      /**
       * Called when a message to a private channel has been sent by some chat member.
       * 
       * @param message instance of <code>MChatMessage</code> that represents the message received. Must
       *                have been borrowed from <code>messagePool</code>. Don't return it to the pool in the
       *                <code>MessagePrivateAction</code>: it will be returned by the
       *                <code>MChatChannelContent</code>.
       *                <b>Not null.</b>
       */
      public function receivePrivateMessage(message: MChatMessage): void {
         Objects.paramNotNull("message", message);

         var member: MChatMember = _members.getMember(message.playerId);
         if (member == null) {
            // message from the player who is offline
            if (message.playerName == null) {
               // server should have sent us playerName
               throw new Error(
                  "Unable to process message: received message " + message
                     + " from offline player but [prop playerName] is missing."
               );
            }
            if (isCompleteIgnored(message.playerName)) {
               return;
            }
            member = new MChatMember(message.playerId, message.playerName);
            _members.addMember(member);
         }

         message.channel = member.name;
         message.playerName = member.name;

         if (isCompleteIgnored(member.name)) {
            return;
         }
         filterMessage(message);

         var channel: MChatChannelPrivate =
                MChatChannelPrivate(_channels.getChannel(message.channel));
         if (channel == null) {
            // conversation initiated by another player
            channel = createPrivateChannel(member);
         }

         channel.receiveMessage(message);
         if (!channel.visible) {
            updateNumPrivateMessages();
         }
      }
      
      
      /* ################################# */
      /* ### MESSAGE SEND CONFIRMATION ### */
      /* ################################# */

      /**
       * Called when a message to a public or private channel has been
       * successfully posted.
       * 
       * @param message the same instance of <code>MChatMessage</code> which
       *                was passed to the <code>MChatChannel.sendMessage()</code>
       *                method. Don't return it to the pool in the action: it
       *                will be returned by the <code>MChatChannelContent</code>.
       *                <b>Not null.</b>
       */
      public function messageSendSuccess(message: MChatMessage): void {
         Objects.paramNotNull("message", message);
         const channel: MChatChannel = _channels.getChannel(message.channel);
         if (channel != null) {
            channel.messageSendSuccess(message);
         }
      }
      
      
      /**
       * Called when a message sent to a public or private channel has been rejected by the server for some
       * reason.
       * 
       * @param message the same instance of <code>MChatMessage</code> which was passed to the
       *                <code>MChatChannel.sendMessage()</code> method. Don't return it to the pool in the
       *                action: it will be returned by the <code>MChatChannelContent</code>.
       *                <b>Not null.</b>
       */
      public function messageSendFailure(message: MChatMessage): void {
         Objects.paramNotNull("message", message);
         
         const channel:MChatChannel = _channels.getChannel(message.channel);
         if (channel == null) {
            /**
             * This is probably not critical error since MChatChannel.messageSendFailure()
             * only returns message to the pool.
             */
            loggerFactory.getLogger("messageSendFailure").warn(
               "Could not find channel '{0}'. Unable to call MChatChannel.messageSendFailure(). "
                  + "Returning MChatMessage to MChat.messagePool. Message was: {1}",
               message.channel, message
            );
            messagePool.returnObject(message);
            return;
         }
         channel.messageSendFailure(message);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getString(property: String,
                                 parameters: Array = null): String {
         return Localizer.string("Chat", property, parameters);
      }

      public function dispatchChatEvent(type:String) : void {
         dispatchSimpleEvent(MChatEvent, type);
      }
      
      private function throwChannelNotFoundError(message:String, channel:String) : void {
         throw new Error(message + ": channel '" + channel + "' not found");
      }
   }
}