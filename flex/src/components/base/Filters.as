package components.base
{
   import flash.filters.ColorMatrixFilter;

   public class Filters
   {
      public static const RED_FILTER: Array =[new ColorMatrixFilter([
         0.7,0,0,0,0, //red
         0,0.1,0,0,0, //green
         0,0,0.1,0,0, //blue
         0,0,0,1,0,])]; //alpha

//      public static const YELLOW_FILTER: Array =[new ColorMatrixFilter([
//         0.8,0,0,0,0, //red
//         0,0.6,0,0,0, //green
//         0,0,0.1,0,0, //blue
//         0,0,0,1,0,])]; //alpha
      
      //demo building filters properties
      public static const GREY_FILTER: Array =[new ColorMatrixFilter([
         0.2,0,0,0,0, //red
         0,0.2,0,0,0, //green
         0,0,0.2,0,0, //blue
         0,0,0,1,0,])]; //alpha
      
      private static const BRIGHTNESS: Number = 0.6;
      public static const GRAYSCALE: Array = [new ColorMatrixFilter([
         0.3086*BRIGHTNESS,0.6094*BRIGHTNESS,0.082*BRIGHTNESS,0,0,
         0.3086*BRIGHTNESS,0.6094*BRIGHTNESS,0.082*BRIGHTNESS,0,0,
         0.3086*BRIGHTNESS,0.6094*BRIGHTNESS,0.082*BRIGHTNESS,0,0,
         0,0,0,1,0])];
   }
}