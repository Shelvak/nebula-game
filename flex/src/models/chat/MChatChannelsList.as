package models.chat
{
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   
   import utils.ClassUtil;
   
   
   /**
    * List of chat channels. Provides O(1) channel lookup by 'name' operations. When modifying this list use
    * <code>addChannel()</code> and <code>removeChannel()</code> methods instead of <code>addItem()</code>,
    * <code>addItemAt()</code>, <code>removeItemAt()</code> and <code>removeAll()</code> methods.
    */
   public class MChatChannelsList extends ArrayCollection
   {
      private var _channelsHash:Object;
      
      
      public function MChatChannelsList()
      {
         super(null);
         _channelsHash = new Object();
//         sort = new Sort();
//         sort.compareFunction = MChat.compareFunction_channels;
//         refresh();
      }
      
      
      /**
       * Adds given <code>MChatChannel</code> to the list.
       * 
       * @param channel instance of <code>MChatChannel</code> to add. <b>Not null</b>.
       * 
       * @throws ArgumentError if given <code>MChatMember</code> is already in the list.
       */
      public function addChannel(channel:MChatChannel) : void
      {
         ClassUtil.checkIfParamNotNull("channel", channel);
         if (containsChannel(channel.name))
         {
            throw new ArgumentError("Channel " + channel + " is already in the list");
         }
         _channelsHash[channel.name] = channel;
         addItem(channel);
      }
      
      
      /**
       * Removes given <code>MChatChannel</code> from the list.
       * 
       * @param channel instance of <code>MChatChannel</code> to remove. <b>Not null</b>.
       * 
       * @throws ArgumentError if given <code>MChatChannel</code> is not in the list and therefore
       * can't be removed.
       */
      public function removeChannel(channel:MChatChannel) : void
      {
         ClassUtil.checkIfParamNotNull("channel", channel);
         var toRemove:MChatChannel = getChannel(channel.name);
         if (toRemove == null)
         {
            throw new ArgumentError("Unable to remove: channel " + channel + " is not in the list");
         }
         removeItemAt(getItemIndex(toRemove));
         delete _channelsHash[toRemove.name];
      }
      
      
      /**
       * Returns instance of <code>MChatChannel</code> with the given <code>id</code>. O(1) complexity.
       * 
       * @param name name of a channel to look for.
       * 
       * @return instance of <code>MChatChannel</code> with the given <code>name</code> or <code>null</code>
       * if there is no such <code>MChatChannel</code>.
       */
      public function getChannel(name:String) : MChatChannel
      {
         return _channelsHash[name];
      }
      
      
      /**
       * Returns <code>true</code> if the list contains <code>MChatChannel</code> with a given
       * <code>name</code>. O(1) complexity.
       */
      public function containsChannel(name:String) : Boolean
      {
         return getChannel(name) != null;
      }
   }
}