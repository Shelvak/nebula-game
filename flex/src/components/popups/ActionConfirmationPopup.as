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
      }
      
      
      /**
       * @see BasePopup#addActionButton()
       */
      public var confirmButtonClickHandler:Function;
      
      
      /**
       * Whether to close the popup when confirm button has been clicked.
       * 
       * @default true
       */
      public var closeOnConfirm:Boolean = true;
      
      
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
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         var btnConfirm:Button = new Button();
         btnConfirm.label = getLabel("confirm");
         addActionButton(btnConfirm, confirmButtonClickHandler, closeOnConfirm);
         
         var btnCancel:Button = new Button();
         btnCancel.label = getLabel("cancel");
         addActionButton(btnCancel, cancelButtonClickHandler, closeOnCancel);
      }
      
      
      private function getLabel(property:String) : String
      {
         return Localizer.string("Popups", "label." + property);
      }
   }
}