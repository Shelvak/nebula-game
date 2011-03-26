package components.buildingselectedsidebar
{
   import components.base.Panel;
   import components.skins.NpcFlankSkin;
   
   public class NpcFlank extends Panel
   {
      public function NpcFlank()
      {
         super();
         setStyle('skinClass', NpcFlankSkin);
      }
      
      import models.unit.UnitsFlank;
      
      import utils.locale.Localizer;
      
      [Bindable]
      public var flankModel: UnitsFlank;
   }
}