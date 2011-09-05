package components.unitsscreen.simple
{
   import components.base.Panel;
   
   import flash.events.MouseEvent;
   
   import models.unit.MCUnit;
   import models.unit.MCUnitScreen;
   
   import spark.components.DataGroup;
   
   public class CUnitScreenFlank extends Panel
   {
      public function CUnitScreenFlank()
      {
         super();
         setStyle('skinClass', UnitScreenFlankSkin);
      }
      
      import components.base.AdvancedList;
      import components.unitsscreen.events.UnitsScreenEvent;
      
      import models.unit.Unit;
      import models.unit.UnitsFlank;
      
      import mx.core.IUIComponent;
      import mx.events.DragEvent;
      import mx.events.FlexEvent;
      import mx.managers.DragManager;
      
      import spark.components.List;
      import spark.events.IndexChangeEvent;
      
      import utils.locale.Localizer;
      
      import components.unitsscreen.events.UnitsScreenEvent;
      
      [Bindable (event="flankModelChange")]
      public function get flankModel(): UnitsFlank
      {
         return _flankModel;
      }
      
      public function set flankModel(value: UnitsFlank): void
      {
         _flankModel = value;
         dispatchFlankModelChangeEvent();
      }
      
      private function dispatchFlankModelChangeEvent(): void
      {
         if (hasEventListener(UnitsScreenEvent.FLANK_MODEL_CHANGE))
         {
            dispatchEvent(new UnitsScreenEvent(UnitsScreenEvent.FLANK_MODEL_CHANGE));
         }
      }
      
      public var _flankModel: UnitsFlank;
      
      private var uScreen: MCUnitScreen = MCUnitScreen.getInstance();
      
      public function unitsList_dragDropHandler(event:MouseEvent):void
      {
         if (uScreen.sourceFlank != null) 
         {
            if (uScreen.sourceFlank != flankModel)
            {
               flankModel.stopDrag();
            }
         }
      }
      
      public function deselectAll(): void
      {
         flankModel.deselectAll();
      }
      
      public function selectAllUnits(): void
      {
         flankModel.selectAll();
      }
      
      [SkinPart (required="true")]
      public var unitsList: DataGroup;
   }
}