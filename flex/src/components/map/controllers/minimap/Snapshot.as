package components.map.controllers.minimap
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   
   import spark.primitives.BitmapImage;
   
   
   /**
    * A component used for taking snapshots of any component.
    */ 
   public class Snapshot extends BitmapImage
   {
      /**
       * Takes a snapshot of a given display object and draws it on this
       * component.
       * 
       * @param source Any display object to take a snapshot of.
       */      
      public function takeSnapshot(source:DisplayObject) : void
      {
         if (!source)
         {
            return;
         }
         
         var matrix: Matrix = new Matrix ();
         matrix.scale(width / source.width, height / source.height);
         
         var bmpData: BitmapData = new BitmapData(width, height, false, 0);
         bmpData.draw(source, matrix);
         
         this.source = bmpData;
      }
   }
}