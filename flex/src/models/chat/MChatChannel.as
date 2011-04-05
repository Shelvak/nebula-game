package models.chat
{
   import models.BaseModel;
   import models.chat.message.converters.ChannelJoinMessageConverter;
   import models.chat.message.converters.ChannelLeaveMessageConverter;
   import models.chat.message.converters.IChatMessageConverter;
   import models.chat.message.processors.ChatMessageProcessor;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.collections.Sort;
   
   import utils.ClassUtil;
   import utils.datastructures.Collections;
   
   
   /**
    * A channel of the chat.
    * 
    * <p>Holds a list of <code>MChatMember</code>s in this channel as an intance of
    * <code>MChatMembersList</code> as well as all its content as an instance of
    * <code>MChatChannelContent</code>.
    * 
    * <p>May be public or private. Private channels only have two <code>MChatMember</code>s.
    * Public and private channel uses different implementations of <code>ChatMessageProcessor</code>.</p>
    */   
   public class MChatChannel extends BaseModel
   {
      private function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      /**
       * 
       * @param name name of the channel. <b>Not null. Not empty string.</b>
       * @param messageProcessor <code>ChatMessageProcessor</code> to use for processing incomming and
       *        outgoing channel messages. <b>Not null.</b>
       * 
       */
      public function MChatChannel(name:String, messageProcessor:ChatMessageProcessor)
      {
         super();
         ClassUtil.checkIfParamNotEquals("name", name, [null, ""]);
         ClassUtil.checkIfParamNotNull("messageProcessor", messageProcessor);
         _name = name;
         _content = new MChatChannelContent();
         _members = new MChatMembersList();
         _processor = messageProcessor;
         _processor.channel = this;
      }
      
      
      private var _processor:ChatMessageProcessor;
      
      
      private var _name:String = null;
      /**
       * Name of this channel. Don't use this as display name. Never null.
       */
      public function get name() : String
      {
         return _name;
      }
      
      
      /* ############### */
      /* ### CONTENT ### */
      /* ############### */
      
      
      private var _content:MChatChannelContent;
      /**
       * Content (messsages) of this channel. Never null.
       */
      public function get content() : MChatChannelContent
      {
         return _content;
      }
      
      
      /* ############### */
      /* ### MEMBERS ### */
      /* ############### */
      
      
      private var _members:MChatMembersList;
      /**
       * List of all channel members. Never null.
       * 
       * <p>Do not modify this list directly. Use <code>memberJoin()</code> and
       * <code>memberLeave()</code> methods</p>.
       */
      public function get members() : MChatMembersList
      {
         return _members;
      }
      
      
      /**
       * Called when a chat member has joined this channel.
       * 
       * @param member new member of the channel
       * 
       * @see MChatMembersList#addMember()
       */
      public function memberJoin(member:MChatMember) : void
      {
         members.addMember(member);
         addMemberExistanceChangeMessage(member, ChannelJoinMessageConverter.getInstance());
      }
      
      
      /**
       * Called when a chat member has left this channel.
       * 
       * @param member a member who has left this channel.
       * 
       * @see MChatMembersList#removeMember()
       */
      public function memberLeave(member:MChatMember) : void
      {
         members.removeMember(member);
         addMemberExistanceChangeMessage(member, ChannelLeaveMessageConverter.getInstance());
      }
      
      
      private function addMemberExistanceChangeMessage(member:MChatMember,
                                                       messageConverter:IChatMessageConverter) : void
      {
         var msg:MChatMessage = MChatMessage(MCHAT.messagePool.borrowObject());
         msg.playerId = member.id;
         msg.playerName = member.name;
         msg.converter = messageConverter;
         content.addMessage(msg.toFlowElement());
         MCHAT.messagePool.returnObject(msg);
      }
   }
}