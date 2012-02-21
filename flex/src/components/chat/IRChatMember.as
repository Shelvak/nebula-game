package components.chat
{
   import components.popups.ActionConfirmationPopup;

   import flash.events.MouseEvent;

   import models.chat.MChatMember;
   import models.chat.events.MChatMemberEvent;

   import mx.core.IVisualElement;

   import spark.components.Button;
   import spark.components.Label;
   import spark.components.supportClasses.ItemRenderer;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalAlign;

   import utils.locale.Localizer;


   /**
    * Item renderer for <code>CChatChannelMembers</code> list in a private
    * channel.
    */
   public class IRChatMember extends ItemRenderer
   {
      public function IRChatMember() {
         super();
         autoDrawBackground = true;
      }


      /* ############# */
      /* ### MODEL ### */
      /* ############# */

      private var _model: MChatMember = null;
      protected function set model(value: MChatMember): void {
         if (_model != value) {
            if (_model != null) {
               _model.removeEventListener(
                  MChatMemberEvent.IS_IGNORED_CHANGE,
                  model_isIgnoredChange, false
               );
            }
            _model = value;
            if (_model != null) {
               _model.addEventListener(
                  MChatMemberEvent.IS_IGNORED_CHANGE,
                  model_isIgnoredChange, false, 0, true
               );
            }
            f_modelChanged = true;
            invalidateProperties();
         }
      }
      protected function get model(): MChatMember {
         return _model;
      }

      protected function modelCommit(): void {
         if (_model != null) {
            lblName.text = _model.name;

            const buttonVisible: Boolean = !_model.isPlayer;
            btnIgnore.visible = buttonVisible;
            btnIgnore.includeInLayout = buttonVisible;
         }
         updateBtnIgnoreLabel();
      }

      private function model_isIgnoredChange(event: MChatMemberEvent): void {
         updateBtnIgnoreLabel();
      }


      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      public override function set data(value: Object): void {
         model = MChatMember(value);
         super.data = value;
      }

      private var f_modelChanged: Boolean = true;

      protected override function commitProperties(): void {
         super.commitProperties();
         if (f_modelChanged) {
            modelCommit();
         }
         f_modelChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */

      private var lblName: Label;
      private var btnIgnore: Button;

      private function updateBtnIgnoreLabel(): void {
         if (btnIgnore != null && _model != null) {
            if (_model.isIgnored) {
               btnIgnore.label = "UI";
            }
            else {
               btnIgnore.label = "I";
            }
         }
      }

      private function btnIgnore_clickHandler(event: MouseEvent): void {
         if (_model != null) {
            if (_model.isIgnored) {
               _model.setIsIgnored(false);
            }
            else {
               const popup: ActionConfirmationPopup =
                        new ActionConfirmationPopup();
               const message: Label = new Label();
               message.left = 0;
               message.right = 0;
               message.text = getString("message", [_model.name]);
               popup.addElement(message);
               popup.cancelButtonVisible = true;
               popup.confirmButtonVisible = true;
               popup.title = getString("title");
               popup.confirmButtonClickHandler = ignoreConfirmed;
               popup.show();
            }
         }
      }

      private function getString(property: String,
                                 parameters: Array = null): String {
         return Localizer.string("Chat", "ignorePopup." + property, parameters);
      }

      private function ignoreConfirmed(button: Button): void {
         _model.setIsIgnored(true);
      }

      protected function createOnlineIcon(): IVisualElement {
         return null;
      }

      protected override function createChildren(): void {
         super.createChildren();

         var layout: HorizontalLayout = new HorizontalLayout();
         layout.gap = 4;
         layout.verticalAlign = VerticalAlign.MIDDLE;
         layout.paddingTop = 4;
         layout.paddingBottom = 4;
         this.layout = layout;

         btnIgnore = new Button();
         btnIgnore.addEventListener(MouseEvent.CLICK, btnIgnore_clickHandler);
         updateBtnIgnoreLabel();
         addElement(btnIgnore);

         const icon: IVisualElement = createOnlineIcon();
         if (icon != null) {
            addElement(icon);
         }

         lblName = new Label();
         addElement(lblName);
      }
   }
}