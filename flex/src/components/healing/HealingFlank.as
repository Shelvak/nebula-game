package components.healing
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.base.AdvancedList;
   import components.base.Panel;
   import components.skins.HealingFlankSkin;
   import components.unitsscreen.events.UnitsScreenEvent;
   
   import controllers.Messenger;
   
   import flash.events.Event;
   
   import globalevents.GHealingScreenEvent;
   import globalevents.GUnitsScreenEvent;
   
   import models.healing.MHealFlank;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;
   
   import spark.components.DataGroup;
   
   import tests.animation.tests.Data;
   
   import utils.locale.Localizer;
   
   public class HealingFlank extends Panel
   {
      public function HealingFlank()
      {
         super();
         setStyle('skinClass', HealingFlankSkin);
      }
      
      public function selectAllRequested(): void
      {
         flankModel.selectAll();
      }
      
      private static const MESSAGE_DURATION: int = Messenger.MEDIUM;
      
      [Bindable]
      public var flankModel: MHealFlank;
      
      public function deselectAll(e: GHealingScreenEvent = null): void
      {
         flankModel.deselectAll();
      }
      
      [SkinPart (required="true")]
      public var unitsList: DataGroup;
   }
}