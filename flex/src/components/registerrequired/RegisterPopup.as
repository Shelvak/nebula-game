package components.registerrequired
{
   import components.popups.ActionConfirmationPopUp;
   import components.skins.GreenButtonSkin;
   import components.skins.YellowButtonSkin;

   import flashx.textLayout.formats.VerticalAlign;

   import spark.layouts.HorizontalAlign;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.supportClasses.LayoutBase;

   import utils.locale.Localizer;


   public class RegisterPopup extends ActionConfirmationPopUp
   {
      public function RegisterPopup() {
         super();
         width = 500;

         confirmButtonLabel = Localizer.string('Players', 'label.registerNow');
         cancelButtonLabel  = Localizer.string('Players', 'label.registerLater');
      }

      override protected function get actionButtonsLayout(): LayoutBase {
         const layout: HorizontalLayout = new HorizontalLayout();
         layout.horizontalAlign = HorizontalAlign.CENTER;
         layout.verticalAlign = VerticalAlign.MIDDLE;
         layout.gap = 20;
         layout.paddingBottom = 10;
         return layout;
      }

      override protected function createChildren(): void {
         super.createChildren();

         btnConfirm.setStyle("skinClass", GreenButtonSkin);
         btnCancel.setStyle("skinClass", YellowButtonSkin);

         addElement(new RegisterPopupContent());
      }
   }
}
