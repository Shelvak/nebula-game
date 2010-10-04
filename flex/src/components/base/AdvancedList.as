package components.base
{
   import flash.events.MouseEvent;
   
   import spark.components.List;

   /**
    * allows multiple selection without holding ctrl, by force setting it to true
    *   
    * @author Jho
    * 
    */   
   public class AdvancedList extends List
   {
      public function AdvancedList()
      {
         super();
      }
      
      
      protected override function item_mouseDownHandler(event:MouseEvent):void
      {
         var e:MouseEvent = event as MouseEvent;
         e.ctrlKey = true;
         super.item_mouseDownHandler(e);
      }
   }
}