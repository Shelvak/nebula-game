package components.movement
{
   import flash.display.GraphicsPathCommand;
   
   import models.Owner;
   
   import spark.components.Group;
   import spark.components.Label;
   
   public class CHopInfo extends Group
   {
      public function CHopInfo()
      {
         super();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public override function set x(value:Number) : void
      {
         super.x = value - width + 10;
      }
      
      
      public override function set y(value:Number) : void
      {
         super.y = value - height - 20;
      }
      
      
      private var _text:String = "";
      public function set text(value:String) : void
      {
         if (_text != value)
         {
            _text = value;
            f_textChanged = true;
            invalidateProperties();
            invalidateDisplayList();
         }
      }
      
      
      private var _squadOwner:int = Owner.ENEMY;
      public function set squadOwner(value:int) : void
      {
         if (_squadOwner != value)
         {
            _squadOwner = value;
            invalidateDisplayList();
         }
      }
      
      
      private var f_textChanged:Boolean = true;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_textChanged)
         {
            _label.text = _text;
         }
         f_textChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var _label:Label;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         _label = new Label();
         _label.left = _label.right = 10;
         _label.top = 6;
         _label.bottom = 4;
         addElement(_label);
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         graphics.clear();
         graphics.beginFill(Owner.getColor(_squadOwner), 0.7);
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