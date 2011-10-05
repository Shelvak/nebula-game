package components.movement
{
   import flash.display.GraphicsPathCommand;
   
   import flashx.textLayout.formats.TextAlign;
   
   import models.Owner;
   import models.OwnerColor;
   
   import spark.components.Group;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalLayout;
   
   public class CHopInfo extends Group
   {
      public function CHopInfo()
      {
         super();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      public override function set x(value:Number) : void {
         super.x = value - width + 10;
      }
      
      public override function set y(value:Number) : void {
         super.y = value - height - 20;
      }
      
      private var _arrivesInVisible:Boolean = false;
      public function set arrivesInVisible(value:Boolean) : void {
         if (_arrivesInVisible != value) {
            _arrivesInVisible = value;
            f_labelsVisibilityChanged = true;
            invalidateProperties();
         }
      }
      public function get arrivesInVisible() : Boolean {
         return _arrivesInVisible;
      }
      
      private var _jumpsInVisible:Boolean = false;
      public function set jumpsInVisible(value:Boolean) : void {
         if (_jumpsInVisible != value) {
            _jumpsInVisible = value;
            f_labelsVisibilityChanged = true;
            invalidateProperties();
         }
      }
      public function get jumpsInVisible() : Boolean {
         return _jumpsInVisible;
      }
      
      private var _arrivesInLabelText:String;
      public function set arrivesInLabelText(value:String) : void {
         if (_arrivesInLabelText != value) {
            _arrivesInLabelText = value;
            f_textChanged = true;
            invalidateProperties();
         }
      }
      public function get arrivesInLabelText() : String {
         return _arrivesInLabelText;
      }

      private var _arrivesInValueText:String;
      public function set arrivesInValueText(value:String) : void {
         if (_arrivesInValueText != value) {
            _arrivesInValueText = value;
            f_textChanged = true;
            invalidateProperties();
         }
      }
      public function get arrivesInValueText() : String {
         return _arrivesInValueText;
      }

      private var _jumpsInLabelText:String;
      public function set jumpsInLabelText(value:String) : void {
         if (_jumpsInLabelText != value) {
            _jumpsInLabelText = value;
            f_textChanged = true;
            invalidateProperties();
         }
      }
      public function get jumpsInLabelText() : String {
         return _jumpsInLabelText;
      }
      
      private var _jumpsInValueText:String;
      public function set jumpsInValueText(value:String) : void {
         if (_jumpsInValueText != value) {
            _jumpsInValueText = value;
            f_textChanged = true;
            invalidateProperties();
         }
      }
      public function get jumpsInValueText() : String {
         return _jumpsInValueText;
      }
      
      
      private var _squadOwner:int = Owner.ENEMY;
      public function set squadOwner(value:int) : void {
         if (_squadOwner != value) {
            _squadOwner = value;
            invalidateDisplayList();
         }
      }
      
      
      private var f_textChanged:Boolean = true;
      private var f_labelsVisibilityChanged:Boolean = true;
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_textChanged) {
            _lblArrivesIn.text = _arrivesInLabelText;
            _lblArrivesInValue.text = _arrivesInValueText;
            _lblJumpsIn.text = _jumpsInLabelText;
            _lblJumpsInValue.text = _jumpsInValueText;
         }
         if (f_labelsVisibilityChanged) {
            _lblArrivesIn.includeInLayout =
            _lblArrivesIn.visible =
            _lblArrivesInValue.includeInLayout =
            _lblArrivesInValue.visible = _arrivesInVisible;
            _lblJumpsIn.includeInLayout =
            _lblJumpsIn.visible =
            _lblJumpsInValue.includeInLayout =
            _lblJumpsInValue.visible = _jumpsInVisible;
         }
         f_textChanged = f_labelsVisibilityChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _lblArrivesIn:Label;
      private var _lblArrivesInValue:Label;
      private var _lblJumpsIn:Label;
      private var _lblJumpsInValue:Label;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         _lblArrivesIn = new Label();
         _lblArrivesIn.setStyle("textAlign", TextAlign.RIGHT);
         _lblArrivesInValue = new Label();
         _lblArrivesInValue.setStyle("textAlign", TextAlign.LEFT);
         _lblJumpsIn = new Label();
         _lblJumpsIn.setStyle("textAlign", TextAlign.RIGHT);
         _lblJumpsInValue = new Label();
         _lblJumpsInValue.setStyle("textAlign", TextAlign.LEFT);
         var containerLayout:HorizontalLayout = new HorizontalLayout();
         containerLayout.gap = 6;
         var container:Group = new Group();
         container.left = 10;
         container.right = 10;
         container.top = 6;
         container.bottom = 4;
         container.layout = containerLayout;
         var labelsContainer:Group = new Group();
         labelsContainer.layout = getLabelsLayout();
         labelsContainer.addElement(_lblArrivesIn);
         labelsContainer.addElement(_lblJumpsIn);
         var valuesContainer:Group = new Group();
         valuesContainer.layout = getLabelsLayout();
         valuesContainer.addElement(_lblArrivesInValue);
         valuesContainer.addElement(_lblJumpsInValue);
         container.addElement(labelsContainer);
         container.addElement(valuesContainer);
         addElement(container);
      }
      
      private function getLabelsLayout() : VerticalLayout {
         var layout:VerticalLayout = new VerticalLayout();
         layout.gap = 2;
         layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
         return layout;
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         graphics.clear();
         graphics.beginFill(OwnerColor.getColor(_squadOwner), 0.7);
         graphics.drawRect(0, 0, uw, uh);
         graphics.drawPath(
            Vector.<int>([
               GraphicsPathCommand.MOVE_TO,
               GraphicsPathCommand.LINE_TO,
               GraphicsPathCommand.LINE_TO
            ]),
            Vector.<Number>([
               uw, uh,
               uw - 10, uh + 20,
               uw - 20, uh
            ])
         );
         graphics.endFill();
      }
   }
}