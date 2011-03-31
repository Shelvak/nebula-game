package models.chat
{
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
       * <code>MChatMessage</code> pool for the chat.
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
         
      }
      
      
      /* ############################## */
      /* ### CHANNEL JOIN AND LEAVE ### */
      /* ############################## */
      
      
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
   }
}