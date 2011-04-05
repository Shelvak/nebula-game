package models.chat
{
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.utils.ObjectUtil;
   
   import utils.SingletonFactory;
   import utils.pool.IObjectPool;
   import utils.pool.impl.StackObjectPoolFactory;
   
   
   /**
    * Chat singleton.
    * 
    * <p>Aggregates all channels and members of the chat.</p>
    */
   public class MChat
   {
      public static function getInstance() : MChat
      {
         return SingletonFactory.getSingletonInstance(MChat);
      }
      
      
      public function MChat()
      {
         _messagePool = new StackObjectPoolFactory(new MChatMessageFactory()).createPool();
      }
      
      
      private var _messagePool:IObjectPool = null;
      /**
       * Returns <code>MChatMessage</code> pool for the chat.
       */
      public function get messagePool() : IObjectPool
      {
         return _messagePool;
      }
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
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
      public function initialize(members:Object, channels:Object) : void
      {
         _members = new MChatMembersList();
         var member:MChatMember;
         for (var chatMemberId:String in members)
         {
            member = new MChatMember();
            member.id = int(chatMemberId);
            member.name = members[chatMemberId];
            _members.addMember(member);
         }
         
         _channels = new ArrayCollection();
         var channel:MChatChannelPublic;
         for (var channelName:String in channels)
         {
            channel = new MChatChannelPublic(channelName);
            for each (var chanMemberId:int in channels[channelName])
            {
               channel.memberJoin(_members.getMember(chanMemberId));
            }
            _channels.addItem(channel);
         }
      }
      
      
      /* ############### */
      /* ### MEMBERS ### */
      /* ############### */
      
      
      private var _members:MChatMembersList;
      /**
       * Lits of all chat members.
       */
      public function get members() : IList
      {
         return _members;
      }
      
      
      /**
       * Function for comparing two <code>MChatMembers</code>. 
       * 
       * @see mx.collections.Sort#compareFunction
       */
      public static function compareFunction_members(m1:MChatMember, m2:MChatMember, fields:Array = null) : int
      {
         var compareResult:int = ObjectUtil.stringCompare(m1.name, m2.name, true);
         if (compareResult != 0)
         {
            return compareResult;
         }
         return ObjectUtil.numericCompare(m1.id, m2.id);
      }
      
      
      /**
       * Called when a player has joined a chat channel.
       * 
       * @param channel name of the channel
       * @param member a member who has joined the channel
       */
      public function channelJoin(channel:String, member:MChatMember) : void
      {
         
      }
      
      
      /**
       * Called when a player has left a chat channel.
       * 
       * @param channel name of the channel
       * @param memberId id of a chat channel member who has left the channel
       */
      public function channelLeave(channel:String, memberId:int) : void
      {
         
      }
      
      
      /* ################ */
      /* ### CHANNELS ### */
      /* ################ */
      
      
      private var _channels:IList;
      /**
       * List of all channels currently open.
       */
      public function get channels() : IList
      {
         return _channels;
      }
      
      
      /* ############################### */
      /* ### PUBLIC CHANNEL MESSAGES ### */
      /* ############################### */
      
      
      /**
       * Called when a message to a public channel has been sent by some chat member.
       * 
       * @param message instance of <code>MChatMessage</code> that represents the message received. Must
       * have been borrowed from <code>messagePool</code>. Don't return it to the pool in the
       * <code>MessagePublicAction</code>: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function publicMessageReceive(message:MChatMessage) : void
      {
         
      }
      
      
      /**
       * Called when a message to a public channel has been successfully posted.
       * 
       * @param message the same instance of <code>MChatMessage</code> which was passed to the
       * <code>sendPublicMessage()</code> method. Don't return it to the pool in the
       * <code>MessagePublicAction</code>: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function publicMessageSendSuccess(message:MChatMessage) : void
      {
         
      }
      
      
      /**
       * Called when a message sent to a public channel has been rejected by the server for some reason.
       * 
       * @param message the same instance of <code>MChatMessage</code> which was passed to the
       * <code>sendPublicMessage()</code> method. Don't return it to the pool in the
       * <code>MessagePublicAction</code>: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function publicMessageSendFailure(message:MChatMessage) : void
      {
         
      }
      
      
      /* ################################ */
      /* ### PRIVATE CHANNEL MESSAGES ### */
      /* ################################ */
      
      
      /**
       * Called when a message to a private channel has been sent by some chat member.
       * 
       * @param message instance of <code>MChatMessage</code> that represents the message received. Must
       * have been borrowed from <code>messagePool</code>. Don't return it to the pool in the
       * <code>MessagePrivateAction</code>: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function privateMessageReceive(message:MChatMessage) : void
      {
         
      }
      
      
      /**
       * Called when a message to a private channel has been successfully posted.
       * 
       * @param message the same instance of <code>MChatMessage</code> which was passed to the
       * <code>sendPrivateMessage()</code> method. Don't return it to the pool in the
       * <code>MessagePrivateAction</code>: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function privateMessageSendSuccess(message:MChatMessage) : void
      {
         
      }
      
      
      /**
       * Called when a message sent to a private channel has been rejected by the server for some reason.
       * 
       * @param message the same instance of <code>MChatMessage</code> which was passed to the
       * <code>sendPrivateMessage()</code> method. Don't return it to the pool in the
       * <code>MessagePrivateAction</code>: it will be returned by the <code>MChatChannelContent</code>.
       */
      public function privateMessageSendFailure(message:MChatMessage) : void
      {
         
      }
   }
}