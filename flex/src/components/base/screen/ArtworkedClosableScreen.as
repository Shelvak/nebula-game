package components.base.screen
{
   import flash.text.engine.FontWeight;
   
   import mx.core.UIComponent;
   
   import spark.components.Group;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;

   public class ArtworkedClosableScreen extends ClosableScreen
   {
      public function ArtworkedClosableScreen()
      {
         super();
         actualContent = new Group();
         actualContent.percentHeight = 100;
         actualContent.percentWidth = 100;
         var screenLayout: VerticalLayout = new VerticalLayout();
         screenLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
         screenLayout.gap = 0;
         actualContent.layout = screenLayout;
         actualContent.addElement(createScreenHeader());
         actualContent.addElement(createMainContent());
         setContent(actualContent);
      }
      
      public function set title(value: String): void
      {
         header.title = value;
      }
      
      private var actualContent: Group;
      private var mainContent: Group;
      private var emptyLabel: Label;
      private var _emptyLabelText: String = '';
      private var _emptyLabelVisible: Boolean = false;
      
      public function set headerContent(value: Group): void
      {
         header.controls = value;
      }
      
      public function set emptyLabelText(value: String): void
      {
         _emptyLabelText = value;
         if (emptyLabel != null)
         {
            emptyLabel.text = value;
         }
      }
      
      public function set emptyLabelVisible(value: Boolean): void
      {
         _emptyLabelVisible = value;
         if (emptyLabel != null)
         {
            emptyLabel.visible = value;
         }
      }
      
      private var _mainAreaContent: UIComponent;
      
      public function set mainAreaContent(value: UIComponent): void
      {
         mainContent.removeAllElements();
         mainContent.addElement(value);
         _mainAreaContent = value;
         emptyLabel = new Label();
         emptyLabel.text = _emptyLabelText;
         emptyLabel.visible = _emptyLabelVisible;
         emptyLabel.horizontalCenter = emptyLabel.verticalCenter = 0;
         emptyLabel.setStyle('fontSize', 36);
         emptyLabel.setStyle('fontWeight', FontWeight.BOLD);
         emptyLabel.setStyle('color', 0x1c1c1c);
         mainContent.addElement(emptyLabel);
      }
      
      public function get mainAreaContent(): UIComponent
      {
         return _mainAreaContent;
      }
      
      public function set seperatorVisible(value: Boolean): void
      {
         header.headerFromContentSeparatorVisible = value;
      }
      
      private var header: ScreenHeader;
      
      private function createScreenHeader(): ScreenHeader
      {
         header = new ScreenHeader();
         return header;
      }
      
      private function createMainContent(): Group
      {
         mainContent = new Group();
         mainContent.percentHeight = 100;
         mainContent.percentWidth = 100;
         return mainContent;
      }
   }
}