package utils.profiler
{
   import ext.flex.mx.collections.ArrayCollection;
   
   import mx.controls.Alert;

   public class Profiler
   {
      public static const enabled:Boolean = false;      
      private static var level:int = -1;
      private static var measures:Array = new Array();
      private static var starts:Array = new Array();
      
      public static function clean():void {
         if (enabled) 
         {
            level = -1;
            measures = new Array();
            starts = new Array();
         }
      }
      
      public static function profile(title:String, code:Function):void {
         start(title);
         code.call();
         end();
      }
      
      public static function start(title:String):void {
         if (enabled)
         {
            level++;
            
            measures.push([level, title, null]);
            
            var index:int = measures.length - 1;
            starts.push([new Date(), index]);
         }
      }
      
      public static function end():void {
         if (enabled)
         {
            var end:Date = new Date();  
            
            var startEntry:Array = starts.pop();
               
            var start:Date = startEntry[0];
            var index:int = startEntry[1];
            measures[index][2] = end.time - start.time;
            
            level--;
         }
      }
      
      public static function writeNumber(msg: String, number: int): void
      {
         if (enabled)
         {
            level++;
            measures.push([level, msg, number]);
            level--;
         }
      }
      
      public static function get resultsString():String {
         if (enabled)
         {
            var out:String = "";
            
            for each (var measure:Array in measures) {
               for (var i:int=0; i < measure[0]; i++) {
                  out += "    ";
               }
               
               out += measure[1] + ': ' + measure[2] + " \n";
            }
            
            return out;
         }
         else
         {
            return "Profiler is disabled via Profiler.enabled";
         }
      }
   }
}