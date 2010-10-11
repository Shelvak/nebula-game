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
      private static var sums: Object = new Object();
      private static var skip: Object = new Object();
      
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
      
      public static function sumStart(title:String):void {
         if (enabled)
         {
            if (sums[title] == null)
            {
               sums[title] = [title, null, (new Date()).time, true];
            }
            else
            {
               if (!sums[title][3])
               {
                  sums[title][2] = new Date().time;
                  sums[title][3] = true;
               }
               else
               {
                  skip[title] = true;
               }
            }
         }
      }
      
      public static function endSum(title:String): void{
         if (enabled)
         {
            if (skip[title])
            {
               skip[title] = null;
               return;
            }
            var end:Number = (new Date()).time;  
            
            var sumsEntry:Array = sums[title];
            var start:Number = sumsEntry[2];
            var durration: Number = end - start;
            if (sumsEntry[1] == null)
            {
               sumsEntry[1] = durration;
            }
            else
            {
               sumsEntry[1] += durration;
            }
            sumsEntry[3] = false;
         }
      }
      
      public static function end(endSums: Array = null):void {
         if (enabled)
         {
            var end:Date = new Date();  
            
            var startEntry:Array = starts.pop();
            var start:Date = startEntry[0];
            var index:int = startEntry[1];
            measures[index][2] = end.time - start.time;
            if (endSums != null)
            {
               for each (var sumTitle: String in endSums)
               {
                  if (sums[sumTitle] != null)
                  {
                     if (!sums[sumTitle][3])
                     {
                        level++;
                        measures.push([level, sums[sumTitle][0], sums[sumTitle][1]]);
                        level--;
                        sums[sumTitle] = null;
                     }
                  }
               }
            }
            
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