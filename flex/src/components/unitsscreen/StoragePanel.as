package components.unitsscreen
{
   import components.skins.StoragePanelSkin;
   
   import flash.events.MouseEvent;
   
   import models.unit.events.UnitEvent;
   
   import spark.components.Button;
   import spark.components.Panel;
   
   
   /**
    * Dispatched when user clicks on bottom right button of this panel
    * 
    * @eventType models.unit.events.UnitEvent.PANEL_BUTTON_CLICK
    */
   [Event(name="panelButtonClick", type="models.unit.events.UnitEvent")]
   
   
   public class StoragePanel extends Panel
   {
      public function StoragePanel() {
         super();
         setStyle("skinClass", StoragePanelSkin);
      }
      
      private var _buttonLabel:String = "";
      [Bindable]
      /**
       * Text of a button. Default is empty string.
       */
      public function set buttonLabel(value:String) : void {
         if (_buttonLabel != value) {
            _buttonLabel = value;
            f_buttonLabelChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get buttonLabel() : String {
         return _buttonLabel;
      }
      
      private var _buttonEnabled:Boolean = true;
      /**
       * Should the button be enabled. Default is <code>true</code>.
       */
      public function set buttonEnabled(value:Boolean) : void {
         if (_buttonEnabled != value) {
            _buttonEnabled = value;
            f_buttonEnabledChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get buttonEnabled() : Boolean {
         return _buttonEnabled;
      }
      
      [Bindable]
      /**
       * Should the button be visible.
       * 
       * @default true
       */
      public var buttonVisible:Boolean = true;
      
      private var f_buttonLabelChanged:Boolean = true,
                  f_buttonEnabledChanged:Boolean = true;
      
      protected override function commitProperties() : void {
         super.commitProperties();
         if (f_buttonEnabledChanged) actionButton.enabled = _buttonEnabled;
         if (f_buttonLabelChanged)   actionButton.label   = _buttonLabel;
         f_buttonEnabledChanged = f_buttonLabelChanged = false;
      }
      
      [SkinPart(required="true")]
      public var actionButton:Button;
      
      protected override function partAdded(partName:String, instance:Object) : void {
         super.partAdded(partName, instance);
         if (instance == actionButton)
            actionButton.addEventListener(MouseEvent.CLICK, dispatchButtonClickEvent);
      }
      
      private function dispatchButtonClickEvent(event:MouseEvent) : void {
         dispatchEvent(new UnitEvent(UnitEvent.PANEL_BUTTON_CLICK));
      }
   }
}