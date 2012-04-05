package components.buildingselectedsidebar
{
   import components.base.Panel;
   import components.skins.NpcFlankSkin;

   import models.unit.MNpcFlank;

   public class NpcFlank extends Panel
   {
      public function NpcFlank()
      {
         super();
         setStyle('skinClass', NpcFlankSkin);
      }
      
      [Bindable]
      public var flankModel: MNpcFlank;
   }
}