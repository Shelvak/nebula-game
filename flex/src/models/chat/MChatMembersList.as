package models.chat
{
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   
   import utils.ClassUtil;
   
   
   /**
    * List of chat members. Provides fast member lookup operation when <code>id</code> is given.
    * For modifications of this list use <code>addMember()</code> and <code>removeMember()</code>
    * methods instead of <code>addItem()</code>, <code>addItemAt()</code>, <code>removeItemAt()</code> and
    * <code>removeAll()</code> methods.
    */
   public class MChatMembersList extends ArrayCollection
   {
      private var _membersHash:Object;
      
      
      public function MChatMembersList()
      {
         super(source);
         _membersHash = new Object();
         sort = new Sort();
         sort.compareFunction = MChat.compareFunction_members;
         refresh();
      }
      
      
      /**
       * Adds given <code>MChatMember</code> to the list.
       * 
       * @param member instance of <code>MChatMember</code> to add. <b>Not null</b>.
       * 
       * @throws ArgumentError if given <code>MChatMember</code> is already in the list.
       */
      public function addMember(member:MChatMember) : void
      {
         ClassUtil.checkIfParamNotNull("member", member);
         if (containsMember(member.id))
         {
            throw new ArgumentError("Member " + member + " is already in the list");
         }
         _membersHash[member.id] = member;
         addItem(member);
      }
      
      
      /**
       * Removes given <code>MChatMember</code> from the list.
       * 
       * @param member instance of <code>MChatMember</code> to remove. <b>Not null</b>.
       * 
       * @throws ArgumentError if given <code>MChatMember</code> is not in the list and therefore
       * can't be removed.
       */
      public function removeMember(member:MChatMember) : void
      {
         ClassUtil.checkIfParamNotNull("member", member);
         var toRemove:MChatMember = getMember(member.id);
         if (toRemove == null)
         {
            throw new ArgumentError("Unable to remove: member " + member + " is not in the list");
         }
         removeItemAt(getItemIndex(toRemove));
         delete _membersHash[toRemove.id];
      }
      
      
      /**
       * Returns instance of <code>MChatMember</code> with the given <code>id</code>. O(1) complexity.
       * 
       * @param id ID of a member to look for.
       * 
       * @return instance of <code>MChatMember</code> with the given <code>id</code> or <code>null</code>
       * if there is no such <code>MChatMember</code>.
       */
      public function getMember(id:int) : MChatMember
      {
         return _membersHash[id];
      }
      
      
      /**
       * Returns <code>true</code> if the list contains <code>MChatMember</code> with a given <code>id</code>.
       * O(1) complexity.
       */
      public function containsMember(id:int) : Boolean
      {
         return getMember(id) != null;
      }
   }
}