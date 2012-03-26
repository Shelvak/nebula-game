package models.chat
{
   import com.adobe.errors.IllegalStateError;

   import models.chat.events.MChatChannelEvent;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.collections.Sort;
   import mx.utils.ObjectUtil;

   import utils.Events;

   import utils.Objects;
   import utils.StringUtil;


   [Event(name="membersFilterChange", type="models.chat.events.MChatChannelEvent")]


   /**
    * List of chat members. Provides fast member lookup operation when
    * <code>id</code> is given. For modifications of this list use
    * <code>addMember()</code> and <code>removeMember()</code> methods instead
    * of <code>addItem()</code>, <code>addItemAt()</code>,
    * <code>removeItemAt()</code> and <code>removeAll()</code> methods.
    */
   public class MChatMembersList extends ArrayCollection
   {
      private static function get MCHAT() : MChat {
         return MChat.getInstance();
      }
      
      
      private var _membersHash:Object;
      private var _channel:MChatChannel;
      
      
      public function MChatMembersList(channel:MChatChannel = null) {
         super(null);
         _channel = channel;
         _membersHash = new Object();
         _dataProvider = new ListCollectionView(this);
         _dataProvider.sort = new Sort();
         _dataProvider.sort.fields = new Array();
         _dataProvider.sort.compareFunction = MChat.compareFunction_members;
         _dataProvider.filterFunction = filterFunction_name;
         _dataProvider.refresh();
      }

      private var _dataProvider: ListCollectionView;
      /**
       * A filtered view over this list.
       *
       * @see #nameFilter
       */
      public function get dataProvider(): IList {
         return _dataProvider;
      }
      
      /**
       * Adds given <code>MChatMember</code> to the list.
       * 
       * @param member instance of <code>MChatMember</code> to add. <b>Not null</b>.
       * 
       * @throws ArgumentError if given <code>MChatMember</code> is already in
       * the list.
       */
      public function addMember(member: MChatMember): void {
         Objects.paramNotNull("member", member);
         if (containsMember(member.id)) {
            throw new ArgumentError(
               "Member " + member + " is already in the list"
            );
         }
         _membersHash[member.id] = member;
         addItem(member);
      }


      /**
       * Removes given <code>MChatMember</code> from the list.
       * 
       * @param member instance of <code>MChatMember</code> to remove. <b>Not null</b>.
       * 
       * @throws ArgumentError if given <code>MChatMember</code> is not in the
       * list and therefore can't be removed.
       */
      public function removeMember(member: MChatMember): void {
         Objects.paramNotNull("member", member);
         var toRemove: MChatMember = getMember(member.id);
         if (toRemove == null) {
            throw new ArgumentError(
               "Unable to remove: member " + member + " is not in the list"
            );
         }
         removeItemAt(getItemIndex(toRemove));
         delete _membersHash[toRemove.id];
      }
      
      
      /**
       * Returns instance of <code>MChatMember</code> with the given
       * <code>id</code>. O(1) complexity.
       * 
       * @param id ID of a member to look for.
       * 
       * @return instance of <code>MChatMember</code> with the given
       * <code>id</code> or <code>null</code> if there is no such
       * <code>MChatMember</code>.
       */
      public function getMember(id:int) : MChatMember {
         return _membersHash[id];
      }

      /**
       * Returns instance of <code>MChatMember</code> with the given
       * <code>name</code>. O(n) complexity.
       *
       * @param name Name of a chat member to look for
       *
       * @return instance of <code>MChatMember</code> with the given
       * <code>name</code> or <code>null</code> if there is no such
       * <code>MChatMember</code>.
       */
      public function getMemberByName(name: String): MChatMember {
         for each (var member:MChatMember in _membersHash) {
            if (member.name == name) {
               return member;
            }
         }
         return null;
      }
      
      /**
       * Returns <code>true</code> if the list contains <code>MChatMember</code>
       * with a given <code>id</code>. O(1) complexity.
       */
      public function containsMember(id:int) : Boolean {
         return getMember(id) != null;
      }
      
      /**
       * Opens private channel to a member with a given id (if the channel is
       * public) or shows corresponding player's profile
       * (if channel is private). O(1) complexity.
       */
      public function openMember(id:int) : void {
         if (_channel == null) {
            throw new IllegalStateError(
               "Unable to perform this operation. [param channel] was not "
                  + "provided for the constructor when this instance was created."
            );
         }
         if (containsMember(id)) {
            if (getMember(id).isPlayer || !_channel.isPublic) {
               getMember(id).showPlayer();
            }
            else {
               MCHAT.openPrivateChannel(id);
            }
         }
         else {
            throw new Error(
               "Unable to open private channel or show player profile of "
                  + "member with id " + id + ": this member is not in the "
                  + "list. The list is:\n" + ObjectUtil.toString(this)
            );
         }
      }

      private function filterFunction_name(member: MChatMember): Boolean {
         if (_nameFilter != null) {
            const name: String = member.name.toLocaleLowerCase();
            const filter: String = _nameFilter.toLocaleLowerCase();
            return name.indexOf(filter) > -1;
         }
         return true;
      }

      private var _nameFilter:String = null;
      [Bindable(event="membersFilterChange")]
      /**
       * Setting this to some non-whitespace string leaves only those members in
       * <code>dataProvider</code> that have a substring equal to the value
       * in their names.
       */
      public function set nameFilter(value: String): void {
         if (value != null) {
            value = StringUtil.trim(value);
            if (value.length == 0) {
               value = null;
            }
         }
         if (_nameFilter != value) {
            _nameFilter = value;
            _dataProvider.refresh();
            Events.dispatchSimpleEvent(
               this, MChatChannelEvent, MChatChannelEvent.MEMBERS_FILTER_CHANGE
            );
         }
      }
      public function get nameFilter(): String {
         return _nameFilter;
      }

      
      /**
       * Removes all members.
       */
      public function reset() : void {
         removeAll();
         nameFilter = null;
         _membersHash = new Object();
      }
   }
}