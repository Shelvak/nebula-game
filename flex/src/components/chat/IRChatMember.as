package components.chat
{
   import flash.display.BitmapData;
   
   import models.chat.MChatMember;
   import models.chat.events.MChatMemberEvent;
   
   import spark.components.Label;
   import spark.components.supportClasses.ItemRenderer;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalAlign;
   import spark.primitives.BitmapImage;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * Item renderer for <code>CChatCahnnelMembers</code> list in a private channel.
    */
   public class IRChatMember extends ItemRenderer
   {
      private static const ICON_KEY_ONLINE:String = "online",
                           ICON_KEY_OFFLINE:String = "offline";
      
      
      public function IRChatMember()
      {
         super();
         autoDrawBackground = true;
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _model:MChatMember = null,
                  _modelOld:MChatMember = null;
      public override function set data(value:Object) : void
      {
         if (_model != value)
         {
            if (_modelOld == null)
            {
               _modelOld = _model
            }
            _model = MChatMember(value);
            f_modelChanged = true;
            invalidateProperties();
            super.data = value;
         }
      }
      
      
      private var f_modelChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_modelChanged)
         {
            if (_modelOld != null)
            {
               _modelOld.removeEventListener(
                  MChatMemberEvent.IS_ONLINE_CHANGE, model_isOnlineChange, false
               );
               _modelOld = null;
            }
            
            if (_model != null)
            {
               _model.addEventListener(
                  MChatMemberEvent.IS_ONLINE_CHANGE, model_isOnlineChange, false, 0, true
               );
               lblName.text = _model.name;
            }
            else
            {
               lblName.text = "";
            }
            
            updateBmpOnlineIndicatorSource();
         }
         f_modelChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var lblName:Label;
      private var bmpOnlineIndicator:BitmapImage;
      private function updateBmpOnlineIndicatorSource() : void
      {
         if (bmpOnlineIndicator != null)
         {
            if (_model != null && _model.isOnline)
            {
               bmpOnlineIndicator.source = getIcon(ICON_KEY_ONLINE);
            }
            else
            {
               bmpOnlineIndicator.source = getIcon(ICON_KEY_OFFLINE);
            }
         }
      }
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         var layout:HorizontalLayout = new HorizontalLayout();
         layout.gap = 4;
         layout.verticalAlign = VerticalAlign.MIDDLE;
         layout.paddingTop = 4;
         layout.paddingBottom = 4;
         this.layout = layout;
         
         bmpOnlineIndicator = new BitmapImage();
         updateBmpOnlineIndicatorSource();
         addElement(bmpOnlineIndicator);
         
         lblName = new Label();
         addElement(lblName);
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function model_isOnlineChange(event:MChatMemberEvent) : void
      {
         updateBmpOnlineIndicatorSource();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getIcon(key:String) : BitmapData
      {
         return ImagePreloader.getInstance().getImage(AssetNames.getIconImageName(key));
      }
   }
}