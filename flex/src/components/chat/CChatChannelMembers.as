package components.chat
{
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;

   import models.chat.MChatMember;
   import models.chat.MChatMembersList;

   import spark.components.List;


   /**
    * List of all members in a <code>MChatChannel</code>
    */
   public class CChatChannelMembers extends List
   {
      public function CChatChannelMembers() {
         super();
         minWidth = 0;
         minHeight = 0;
         doubleClickEnabled = true;
         allowMultipleSelection = false;
         labelField = "name";
      }


      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      private var _model: MChatMembersList;
      /**
       * List of <code>MChatMember</code>s.
       */
      public function set model(value: MChatMembersList): void {
         if (_model != value) {
            _model = value;
            f_modelChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get model(): MChatMembersList {
         return _model;
      }

      private var f_modelChanged: Boolean = true;

      protected override function commitProperties(): void {
         super.commitProperties();
         if (f_modelChanged) {
            if (_model != null) {
               addSelfEventHandlers();
            }
            else {
               removeSelfEventHandler();
            }
            dataProvider = _model != null ? _model.dataProvider : null;
         }
         f_modelChanged = false;
      }

      /**
       * <code>MChatMember</code> that is currently selected.
       */
      private function get selectedMember(): MChatMember {
         return MChatMember(selectedItem);
      }


      /* ############# */
      /* ### LOGIC ### */
      /* ############# */

      private function openMember(): void {
         if (selectedMember != null) {
            model.openMember(selectedMember.id)
         }
      }


      /* ########################### */
      /* ### SELF EVENT HANDLERS ### */
      /* ########################### */

      private function addSelfEventHandlers(): void {
         addEventListener(
            FocusEvent.FOCUS_OUT, this_focusOutHandler, false, 0, true
         );
         addEventListener(
            MouseEvent.DOUBLE_CLICK, this_doubleClickHandler, false, 0, true
         );
         addEventListener(
            KeyboardEvent.KEY_UP, this_keyUpHandler, false, 0, true
         );
      }

      private function removeSelfEventHandler(): void {
         removeEventListener(
            FocusEvent.FOCUS_OUT, this_focusOutHandler, false
         );
         removeEventListener(
            MouseEvent.DOUBLE_CLICK, this_doubleClickHandler, false
         );
         removeEventListener(
            KeyboardEvent.KEY_UP, this_keyUpHandler, false
         );
      }

      private function this_focusOutHandler(event: FocusEvent): void {
         // deselect when focus is lost
         selectedIndex = -1;
      }

      private function this_doubleClickHandler(event: MouseEvent): void {
         openMember();
      }

      private function this_keyUpHandler(event: KeyboardEvent): void {
         if (event.keyCode == Keyboard.ENTER) {
            openMember();
         }
      }
   }
}