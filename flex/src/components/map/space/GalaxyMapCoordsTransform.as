package components.map.space
{
   import components.map.BaseMapCoordsTransform;
   import components.movement.CSquadronMapIcon;
   
   import models.galaxy.Galaxy;
   
   import utils.Objects;
   
   public class GalaxyMapCoordsTransform extends BaseMapCoordsTransform
   {
      public static const SECTOR_WIDTH:Number = CSquadronMapIcon.WIDTH * 4 + SquadronsLayout.GAP * 3;
      public static const SECTOR_HEIGHT:Number = CSquadronMapIcon.HEIGHT * 4 + SquadronsLayout.GAP * 3;
      
      private var _galaxy:Galaxy;
      
      public function GalaxyMapCoordsTransform(model:Galaxy) {
         _galaxy = Objects.paramNotNull("model", model);
      }
      
      public override function get realWidth() : Number {
         return SECTOR_WIDTH * _galaxy.bounds.width;
      }
      
      public override function get realHeight() : Number {
         return SECTOR_HEIGHT * _galaxy.bounds.height;
      }
      
      /**
       * @param logicalY Not used
       * 
       * @see components.map.IMapCoordsTransform#logicalToReal_X()
       */
      public override function logicalToReal_X(logicalX:int, logicalY:int) : Number {
         return (logicalX + _galaxy.offset.x + 0.5) * SECTOR_WIDTH;
      }
      
      /**
       * @param logicalX Not used
       * 
       * @see components.map.IMapCoordsTransform#logicalToReal_Y()
       */
      public override function logicalToReal_Y(logicalX:int, logicalY:int) : Number {
         return (_galaxy.bounds.height - (logicalY + _galaxy.offset.y) - 0.5) * SECTOR_HEIGHT;
      }
      
      /**
       * @param realY Not used
       * 
       * @see components.map.IMapCoordsTransform#realToLogical_X()
       */
      public override function realToLogical_X(realX:Number, realY:Number) : int {
         return Math.round(realX / SECTOR_WIDTH - _galaxy.offset.x - 0.5);
      }
      
      /**
       * @param realX Not used
       * 
       * @see components.map.IMapCoordsTransform#realToLogical_Y()
       */      
      public override function realToLogical_Y(realX:Number, realY:Number) : int {
         return Math.round(_galaxy.bounds.height - 0.5 - realY / SECTOR_HEIGHT - _galaxy.offset.y);
      }
   }
}