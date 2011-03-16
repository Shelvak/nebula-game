package components.popups
{
   import spark.components.Button;
   
   import utils.Localizer;
   
   
   /**
    * Base popup that provides user with two choises: either confirm action or cancel it.
    */
   public class ActionConfirmationPopup extends BasePopup
   {
      public function ActionConfirmationPopup()
      {
         super();
         _confirmButtonLabel = getLabel("confirm");
         _confirmButtonEnabled = true;
         _cancelButtonLabel = getLabel("cancel");
         _cancelButtonEnabled = true;
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      /**
       * @see BasePopup#addActionButton()
       */
      public var confirmButtonClickHandler:Function;
      
      
      private var _confirmButtonLabel:String;
      /**
       * Set to change a label of confirm button.
       */
      public function set confirmButtonLabel(value:String) : void
      {
         if (_confirmButtonLabel != value)
         {
            _confirmButtonLabel = value;
            f_confirmButtonLabelChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get confirmButtonLabel() : String
      {
         return _confirmButtonLabel;
      }
      
      
      private var _confirmButtonEnabled:Boolean;
      /**
       * Change to enable or disable confirm button.
       */
      public function set confirmButtonEnabled(value:Boolean) : void
      {
         if (_confirmButtonEnabled != value)
         {
            _confirmButtonEnabled = value;
            f_confirmButtonEnabledChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get confirmButtonEnabled() : Boolean
      {
         return _confirmButtonEnabled;
      }
      
      
      /**
       * Whether to close the popup when confirm button has been clicked.
       * 
       * @default true
       */
      public var closeOnConfirm:Boolean = true;
      
      
      private var _cancelButtonLabel:String;
      /**
       * Set to change a label of confirm button.
       */
      public function set cancelButtonLabel(value:String) : void
      {
         if (_cancelButtonLabel != value)
         {
            _cancelButtonLabel = value;
            f_cancelButtonLabelChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get cancelButtonLabel() : String
      {
         return _cancelButtonLabel;
      }
      
      
      private var _cancelButtonEnabled:Boolean;
      /**
       * Change to enable or disable confirm button.
       */
      public function set cancelButtonEnabled(value:Boolean) : void
      {
         if (_cancelButtonEnabled != value)
         {
            _cancelButtonEnabled = value;
            f_cancelButtonEnabledChanged = true;
            invalidateProperties();
         }
      }
      /**
       * @private
       */
      public function get cancelButtonEnabled() : Boolean
      {
         return _cancelButtonEnabled;
      }
      
      
      /**
       * @see BasePopup#addActionButton()
       */
      public var cancelButtonClickHandler:Function;
      
      
      /**
       * Whether to close the popup when cancel button has been clicked.
       * 
       * @default true
       */
      public var closeOnCancel:Boolean = true;
      
      
      private var f_confirmButtonLabelChanged:Boolean = true,
                  f_confirmButtonEnabledChanged:Boolean = true,
                  f_cancelButtonLabelChanged:Boolean = true,
                  f_cancelButtonEnabledChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_cancelButtonEnabledChanged)
         {
            _btnCancel.enabled = _cancelButtonEnabled;
         }
         if (f_cancelButtonLabelChanged)
         {
            _btnCancel.label = _cancelButtonLabel;
         }
         if (f_confirmButtonEnabledChanged)
         {
            _btnConfirm.enabled = _confirmButtonEnabled;
         }
         if (f_confirmButtonLabelChanged)
         {
            _btnConfirm.label = _confirmButtonLabel;
         }
         
         f_cancelButtonEnabledChanged =
         f_cancelButtonLabelChanged =
         f_confirmButtonEnabledChanged =
         f_confirmButtonLabelChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _btnConfirm:Button,
                  _btnCancel:Button;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         _btnConfirm = new Button();
         addActionButton(_btnConfirm, confirmButtonClickHandler, closeOnConfirm);
         
         _btnCancel = new Button();
         addActionButton(_btnCancel, cancelButtonClickHandler, closeOnCancel);
      }
      
      
      private function getLabel(property:String) : String
      {
         return Localizer.string("Popups", "label." + property);
      }
   }
}