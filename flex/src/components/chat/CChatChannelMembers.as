package components.chat
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   
   import models.chat.MChat;
   import models.chat.MChatMember;
   import models.chat.MChatMembersList;
   
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   
   import spark.components.List;
   import spark.events.IndexChangeEvent;
   
   import utils.ClassUtil;
   
   
   /**
    * List of all members in a <code>MChatChannel</code>
    */
   public class CChatChannelMembers extends List
   {
      private function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      /**
       * @param members list of <code>MChatMember</code>s. <b>Not null.</b>
       */
      public function CChatChannelMembers(members:MChatMembersList)
      {
         super();
         ClassUtil.checkIfParamNotNull("members", members);
         
         dataProvider = members;
         
         minWidth = 0;
         minHeight = 0;
         doubleClickEnabled = true;
         allowMultipleSelection = false;
         labelField = "name";
         
         addSelfEventHandlers();
      }
      
      
      /**
       * <code>MChatMember</code> that is currently selected.
       */
      private function get selectedMember() : MChatMember
      {
         return MChatMember(selectedItem);
      }
      
      
      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(MouseEvent.DOUBLE_CLICK, this_doubleClickHandler, false, 0, true);
         addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler, false, 0, true);
      }
      
      
      private function removeSelfEventHandler() : void
      {
         removeEventListener(MouseEvent.DOUBLE_CLICK, this_doubleClickHandler, false);
         removeEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler, false);
      }
      
      
      private function this_focusOutHandler(event:FocusEvent) : void
      {
         // deselect when focus is lost
         selectedIndex = -1;
      }
      
      
      private function this_doubleClickHandler(event:MouseEvent) : void
      {
         if (selectedMember != null)
         {
            // Open a private channel if we have a member selected.
            // All checks are performed by MChat.
            MCHAT.openPrivateChannel(selectedMember.id);
         }
      }
      
      
      /**
       * Cleanup here. This component is not reusable.
       */
      private function this_removedFromStageHandler(event:Event) : void
      {
         removeSelfEventHandler();
         dataProvider = null;
      }
   }
}