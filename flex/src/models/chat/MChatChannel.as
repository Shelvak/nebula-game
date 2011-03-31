package models.chat
{
   import models.BaseModel;
   
   
   /**
    * A channel of the chat.
    * 
    * <p>Holds a list of <code>MChatMember</code>s in this channel as well as all its content as an instance
    * of <code>MChatChannelContent</code>.</code>
    * 
    * <p>May be public or private. Private channels only have two <code>MChatMember</code>s.
    * Public and private channel uses different implementations of <code>ChatMessageProcessor</code>.</p>
    */   
   public class MChatChannel extends BaseModel
   {
      public function MChatChannel()
      {
         super();
      }
   }
}