package models.chat
{
   import models.BaseModel;
   import models.chat.events.MChatMemberEvent;
   
   
   /**
    * @see models.chat.events.MChatMemberEvent#IS_ONLINE_CHANGE
    */
   [Event(name="isOnlineChange", type="models.chat.events.MChatMemberEvent")]
   
   
   /**
    * Member of the chat (not using <code>PlayerMinimal</code> because binding is not needed here).
    * Not pooled.
    * 
    * @param id id of a chat member
    * @param name name of a chat member
    * @param isOnline whether this member is online or offline
    */
   public class MChatMember extends BaseModel
   {
      public function MChatMember(id:int = 0, name:String = null, isOnline:Boolean = false)
      {
         super();
         this.id = id;
         this.name = name;
         this.isOnline = isOnline;
      }
      
      
      /**
       * Name of the member (player actually).
       * 
       * @default null
       */
      public var name:String;
      
      
      private var _isOnline:Boolean;
      [Bindable(event="isOnlineChange")]
      /**
       * Indicates if this chat member is actually online. The fact that an instance is in
       * <code>MChat.members</code> list does not mean that this member is online (see
       * <code>TCMChat_memberOnlineStatus</code>).
       * 
       * <p>
       * When this property changes <code>MChatMemberEvent.IS_ONLINE_CHANGE</code> event is dispatched.<br/>
       * No property change event.<br/>
       * Default is <code>false</code>.
       * </p>
       * 
       * <p>Metadata:
       * [Bindable(event="isOnlineChange")]
       * </p>
       */
      public function set isOnline(value:Boolean) : void
      {
         if (_isOnline != value)
         {
            _isOnline = value;
            dispatchSimpleEvent(MChatMemberEvent, MChatMemberEvent.IS_ONLINE_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get isOnline() : Boolean
      {
         return _isOnline;
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      
      public override function toString() : String
      {
         return "[class: " + className +
                ", id: " + id +
                ", name: " + name +
                ", isOnline:" + isOnline + "]";
      }
   }
}