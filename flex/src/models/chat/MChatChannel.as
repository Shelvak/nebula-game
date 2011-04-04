package models.chat
{
   import models.BaseModel;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.collections.Sort;
   
   import utils.datastructures.Collections;
   
   
   /**
    * A channel of the chat.
    * 
    * <p>Holds a list of <code>MChatMember</code>s in this channel as an intance of
    * <code>MChatMembersList</code> as well as all its content as an instance of
    * <code>MChatChannelContent</code>.
    * 
    * <p>May be public or private. Private channels only have two <code>MChatMember</code>s.
    * Public and private channel uses different implementations of <code>MChatMessageProcessor</code>.</p>
    */   
   public class MChatChannel extends BaseModel
   {
      public function MChatChannel(messageProcessor:MChatMessageProcessor)
      {
         super();
         _content = new MChatChannelContent();
         _members = new MChatMembersList();
         _processor = messageProcessor;
         _processor.channel = this;
      }
      
      
      private var _processor:MChatMessageProcessor;
      
      
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
         
      }
   }
}