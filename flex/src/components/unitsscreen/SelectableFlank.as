package components.unitsscreen
{
   import components.base.Panel;
   import components.skins.SelectableFlankSkin;
   
   import models.unit.UnitsFlank;
   
   import spark.components.DataGroup;
   
   public class SelectableFlank extends Panel
   {
      public function SelectableFlank()
      {
         super();
         setStyle('skinClass', SelectableFlankSkin);
      }
      
      public function selectAllRequested(): void
      {
         flankModel.selectAll();
      }
      
      [Bindable]
      public var flankModel: UnitsFlank;
      
      public function deselectAll(): void
      {
         flankModel.deselectAll();
      }
      
      [SkinPart (required="true")]
      public var unitsList: DataGroup;
   }
}