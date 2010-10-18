package components.movement
{
   import components.map.space.IMapSpaceObject;
   
   import models.Owner;
   import models.location.LocationMinimal;
   import models.movement.MSquadron;
   
   import spark.components.Group;
   
   import utils.ClassUtil;
   
   
   public class CSquadronMapIcon extends Group implements IMapSpaceObject
   {
      public static const WIDTH:Number = 16;
      public static const HEIGHT:Number = WIDTH;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function CSquadronMapIcon()
      {
         super();
         width = WIDTH;
         height = HEIGHT;
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         var fillColor:uint = 0xFF00FF;
         graphics.clear();
         switch (squadronOwner)
         {
            case Owner.PLAYER:
               fillColor = 0x00FF00;
               break;
            case Owner.ALLY:
               fillColor = 0x0000FF;
               break;
            case Owner.NAP:
               fillColor = 0xFFFF00;
               break;
            case Owner.ENEMY:
               fillColor = 0xFF0000;
               break;
         }
         graphics.beginFill(fillColor);
         graphics.drawRect(0, 0, uw, uh);
         graphics.endFill();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _squadron:MSquadron;
      public function set squadron(value:MSquadron) : void
      {
         if (_squadron != value)
         {
            _squadron = value;
            invalidateDisplayList();
         }
      }
      public function get squadron() : MSquadron
      {
         return _squadron;
      }
      
      
      public function get squadronOwner() : int
      {
         return _squadron.owner;
      }
      
      
      public function get currentLocation() : LocationMinimal
      {
         return _squadron.currentHop.location;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public override function toString() : String
      {
         return "[class: " + ClassUtil.getClassName(this) + ", currentLocation: " + currentLocation +
                ", squadron: " + _squadron + "]";
      }
   }
}