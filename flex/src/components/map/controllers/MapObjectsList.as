package components.map.controllers
{
   import globalevents.GMapEvent;
   
   import models.BaseModel;
   
   import spark.components.List;
   
   
   public class MapObjectsList extends List
   {
      protected override function itemSelected(index:int, selected:Boolean) : void
      {
         super.itemSelected(index, selected);
         if (selected && index >= 0)
         {
            new GMapEvent(GMapEvent.SELECT_OBJECT, BaseModel(dataProvider.getItemAt(index)));
            selectedIndex = -1;
         }
      }
   }
}
