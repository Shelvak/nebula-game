package components.base
{
   import flash.filters.ColorMatrixFilter;

   public class Filters
   {
      public static const redFilter: Array =[new ColorMatrixFilter([
         0.7,0,0,0,0, //red
         0,0.1,0,0,0, //green
         0,0,0.1,0,0, //blue
         0,0,0,1,0,])]; //alpha
      
      //demo building filters properties
      public static const greyFilter: Array =[new ColorMatrixFilter([
         0.2,0,0,0,0, //red
         0,0.2,0,0,0, //green
         0,0,0.2,0,0, //blue
         0,0,0,1,0,])]; //alpha
   }
}