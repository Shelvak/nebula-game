package components.base.screen
{
   import components.base.Scroller;
   import components.screens.ScreenCloseButton;
   
   import controllers.ui.NavigationController;
   
   import flash.events.MouseEvent;
   
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   
   import spark.components.Group;
   import spark.components.List;
   
   import utils.locale.Localizer;
   
   public class ClosableScreen extends Group
   {
      public function ClosableScreen()
      {
         super();
         percentWidth = 100;
         percentHeight = 100;
      }
      
      public function closeFunction(e: MouseEvent): void
      {
         NavigationController.getInstance().showPreviousScreen();
      }
      
      public var closeBtn: ScreenCloseButton;
      
      public var paddingGroup: Group;
      
      private var _scroller: Scroller;
      
      public var bottomPadding: Number = 87;
      
      public function set scroller(value: Scroller): void
      {
         closeBtn.scroller = value;
         _scroller = value;
         paddingGroup = new Group();
         paddingGroup.height = bottomPadding;
         paddingGroup.y = _scroller.viewport.contentHeight;
         dontReposition = true;
         Group(_scroller.viewport).addEventListener(FlexEvent.UPDATE_COMPLETE, repositionPaddingGroup);
         Group(_scroller.viewport).addElement(paddingGroup);
      }
      
      private var dontReposition: Boolean = false;
      
      public function repositionPaddingGroup(e: FlexEvent): void
      {
         var containsGroup: Boolean = Group(_scroller.viewport).contains(paddingGroup);
         if (_scroller.viewport.contentHeight < 
            _scroller.height - (containsGroup ? 0: bottomPadding))
         {
            if (containsGroup)
            {
               Group(_scroller.viewport).removeElement(paddingGroup);
            }
         }
         else
         {
            if (dontReposition)
            {
               dontReposition = false;
               return;
            }
            if (containsGroup)
            {
               Group(_scroller.viewport).removeElement(paddingGroup);
            }
            else if (_scroller.viewport.contentHeight > _scroller.height)
            {
               dontReposition = true;
               paddingGroup.y = _scroller.viewport.contentHeight;
               Group(_scroller.viewport).addElement(paddingGroup);
            }
         }
      }
      
      public function setContent(content: UIComponent): void
      {
         removeAllElements();
         addElement(new ScreenBackground());
         addElement(content);
         closeBtn = new ScreenCloseButton();
         closeBtn.right = 0;
         closeBtn.bottom = 0;
         closeBtn.label = Localizer.string("Squadrons", "label.close");
         closeBtn.addEventListener(MouseEvent.CLICK, closeFunction);
         addElement(closeBtn);
      }
   }
}