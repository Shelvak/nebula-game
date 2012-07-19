package components.map.space.galaxy.entiregalaxy
{
   import flash.display.BitmapData;

   internal final class LegendEntry
   {
      public function LegendEntry(image: BitmapData, text: String) {
         this.image = image;
         this.text = text;
      }

      public var image: BitmapData;
      public var text: String;
   }
}
