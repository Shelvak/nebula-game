package components.chat
{
   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   import models.chat.MChatMember;
   import models.chat.events.MChatMemberEvent;

   import spark.components.Button;

   import spark.components.Label;
   import spark.components.supportClasses.ItemRenderer;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalAlign;
   import spark.primitives.BitmapImage;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * Item renderer for <code>CChatChannelMembers</code> list in a private
    * channel.
    */
   public class IRChatMember extends ItemRenderer
   {
      private static const ICON_KEY_ONLINE:String = "online";
      private static const ICON_KEY_OFFLINE:String = "offline";

      public function IRChatMember() {
         super();
         autoDrawBackground = true;
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      private var _model: MChatMember = null;

      public override function set data(value: Object): void {
         if (_model != value) {
            if (_model != null) {
               _model.removeEventListener(
                  MChatMemberEvent.IS_ONLINE_CHANGE,
                  model_isOnlineChange, false
               );
               _model.removeEventListener(
                  MChatMemberEvent.IS_IGNORED_CHANGE,
                  model_isIgnoredChange, false
               );
            }
            _model = MChatMember(value);
            if (_model != null) {
               _model.addEventListener(
                  MChatMemberEvent.IS_ONLINE_CHANGE,
                  model_isOnlineChange, false, 0, true
               );
               _model.addEventListener(
                  MChatMemberEvent.IS_IGNORED_CHANGE,
                  model_isIgnoredChange, false, 0, true
               );
            }
            f_modelChanged = true;
            invalidateProperties();
            super.data = value;
         }
      }

      private var f_modelChanged: Boolean = true;

      protected override function commitProperties(): void {
         super.commitProperties();

         if (f_modelChanged) {
            if (_model != null) {
               lblName.text = _model.name;

               const buttonVisible: Boolean = !_model.isPlayer;
               btnIgnore.visible = buttonVisible;
               btnIgnore.includeInLayout = buttonVisible;
            }
            updateBtnIgnoreLabel();
            updateBmpOnlineIndicatorSource();
         }
         f_modelChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */


      private var lblName: Label;
      private var btnIgnore: Button;
      private var bmpOnlineIndicator: BitmapImage;

      private function updateBmpOnlineIndicatorSource(): void {
         if (bmpOnlineIndicator != null) {
            if (_model != null && _model.isOnline) {
               bmpOnlineIndicator.source = getIcon(ICON_KEY_ONLINE);
            }
            else {
               bmpOnlineIndicator.source = getIcon(ICON_KEY_OFFLINE);
            }
         }
      }

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

         bmpOnlineIndicator = new BitmapImage();
         updateBmpOnlineIndicatorSource();
         addElement(bmpOnlineIndicator);

         lblName = new Label();
         addElement(lblName);
      }

      private function btnIgnore_clickHandler(event: MouseEvent): void {
         if (_model != null) {
            _model.setIsIgnored(!_model.isIgnored);
         }
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */

      private function model_isOnlineChange(event: MChatMemberEvent): void {
         updateBmpOnlineIndicatorSource();
      }

      private function model_isIgnoredChange(event: MChatMemberEvent): void {
         updateBtnIgnoreLabel();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getIcon(key: String): BitmapData {
         return ImagePreloader.getInstance().getImage(AssetNames.getIconImageName(key));
      }
   }
}