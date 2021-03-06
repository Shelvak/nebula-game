package models.chat
{
   import controllers.ui.NavigationController;

   import models.BaseModel;
   import models.chat.events.MChatMemberEvent;

   import namespaces.prop_name;

   import utils.autocomplete.IAutoCompleteValue;


   [Event(name="isOnlineChange", type="models.chat.events.MChatMemberEvent")]
   [Event(name="isIgnoredChage", type="models.chat.events.MChatMemberEvent")]
   [Event(name="nameChange", type="models.chat.events.MChatMemberEvent")]
   
   
   /**
    * Member of the chat (not using <code>PlayerMinimal</code> because binding
    * is not needed here). Not pooled.
    * 
    * @param id id of a chat member
    * @param name name of a chat member
    * @param isOnline whether this member is online or offline
    * @param isIgnored whether this member is ignored
    */
   public class MChatMember extends BaseModel implements IAutoCompleteValue
   {
      public function MChatMember(
         id: int = 0, name: String = null, isOnline: Boolean = false, isIgnored: Boolean = false)
      {
         super();
         this.id = id;
         this.name = name;
         this.isOnline = isOnline;
         this.isIgnored = isIgnored;
      }

      static prop_name const name: String = "name";
      private var _name: String;
      [Bindable(event="nameChange")]
      /**
       * Name of the member (player actually).
       *
       * @default null
       */
      public function set name(value: String): void {
         if (_name != value) {
            const oldValue: String = _name;
            _name = value;
            dispatchSimpleEvent(MChatMemberEvent, MChatMemberEvent.NAME_CHANGE);
            dispatchPropertyUpdateEvent(prop_name::name, value, oldValue, this);
         }
      }
      public function get name(): String {
         return _name;
      }

      public function get autoCompleteValue(): String {
         return name;
      }


      /**
       * <code>true</code> if this instance of <code>MChatMember</code>
       * represents current player or <code>false</code> otherwise.
       */
      public function get isPlayer(): Boolean {
         return ML.player != null && ML.player.id == id;
      }

      private var _isOnline: Boolean;
      [Bindable(event="isOnlineChange")]
      /**
       * Indicates if this chat member is actually online. The fact that an
       * instance is in <code>MChat.members</code> list does not mean that this
       * member is online (see <code>TCMChat_memberOnlineStatus</code>).
       *
       * <p>
       * When this property changes
       * <code>MChatMemberEvent.IS_ONLINE_CHANGE</code> event is
       * dispatched.<br/>
       * No property change event.<br/>
       * Default is <code>false</code>.
       * </p>
       *
       * <p>Metadata:
       * [Bindable(event="isOnlineChange")]
       * </p>
       */
      public function set isOnline(value: Boolean): void {
         if (_isOnline != value) {
            _isOnline = value;
            dispatchSimpleEvent(
               MChatMemberEvent, MChatMemberEvent.IS_ONLINE_CHANGE
            );
         }
      }

      /**
       * @private
       */
      public function get isOnline(): Boolean {
         return _isOnline;
      }

      private var _isIgnored: Boolean;
      [Bindable(event="isIgnoredChange")]
      public function set isIgnored(isIgnored: Boolean): void {
         if (_isIgnored != isIgnored) {
            _isIgnored = isIgnored;
            dispatchSimpleEvent(
               MChatMemberEvent, MChatMemberEvent.IS_IGNORED_CHANGE
            );
         }
      }
      /**
       * @private
       */
      public function get isIgnored(): Boolean {
         return _isIgnored;
      }
      
      public function showPlayer() : void {
         NavigationController.getInstance().showPlayer(id);
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function toString() : String
      {
         return "[class: " + className
                   + ", id: " + id
                   + ", name: " + name
                   + ", isOnline: " + isOnline
                   + ", isIgnored: " + isIgnored + "]";
      }

      public function setIsIgnored(ignored: Boolean): void {
         if (isIgnored == ignored) {
            return;
         }
         const chat:MChat = MChat.getInstance();
         if (ignored) {
            chat.ignoredMembers.addToIgnoreList(name);
         }
         else {
            chat.ignoredMembers.removeFromIgnoreList(name);
         }
      }
   }
}