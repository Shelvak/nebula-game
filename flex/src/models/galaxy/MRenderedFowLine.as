package models.galaxy
{
   import components.map.space.galaxy.entiregalaxy.Colors;
   import components.map.space.galaxy.entiregalaxy.EntireGalaxyRenderer;
   
   import flash.display.BitmapData;
   
   import utils.ObjectStringBuilder;

   
   public final class MRenderedFowLine extends MRenderedObjectType
   {
      public function MRenderedFowLine(entireGalaxy: IMEntireGalaxy) {
         super(entireGalaxy);
      }
      
      override public function get legendText(): String {
         return getString("border");
      }
      
      override public function get legendImage(): BitmapData {
         const sectorSize: uint = EntireGalaxyRenderer.SECTOR_SIZE;
         return new BitmapData(sectorSize, sectorSize, false, Colors.BORDER_COLOR);
      }
      
      override public function equals(o: Object): Boolean {
         return o is MRenderedFowLine;
      }
      
      public function toString(): String {
         return new ObjectStringBuilder(this).finish();
      }
   }
}