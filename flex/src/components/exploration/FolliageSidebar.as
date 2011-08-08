package components.exploration
{
   import components.base.ImageAndLabel;
   import components.base.Panel;
   import components.base.Warning;
   import components.exploration.skins.FolliageSidebarSkin;
   
   import flash.events.MouseEvent;
   
   import globalevents.GlobalEvent;
   
   import models.exploration.ExplorationStatus;
   import models.exploration.events.ExplorationStatusEvent;
   import models.resource.ResourceType;
   
   import spark.components.Button;
   import spark.components.Label;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.primitives.BitmapImage;
   
   import utils.DateUtil;
   import utils.UrlNavigate;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;
   
   
   [SkinState("startExploration")]
   [SkinState("noResearchCenter")]
   [SkinState("explorationUderway")]
   [SkinState("planetNotOwned")]
   public class FolliageSidebar extends SkinnableComponent
   {
      private function get IMG() : ImagePreloader {
         return ImagePreloader.getInstance();
      }
      
      
      private function get status() : ExplorationStatus {
         return ExplorationStatus.getInstance();
      }
            
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      public function FolliageSidebar() {
         super();
         status.addEventListener(ExplorationStatusEvent.STATUS_CHANGE, status_statusChangeHandler);
         setStyle("skinClass", FolliageSidebarSkin);  
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private var f_statusChanged:Boolean = true,
                  f_timeLeftChanged:Boolean = true;
      
      protected override function commitProperties() : void {
         super.commitProperties();
         
         if (f_statusChanged) {
            updateBtnExplore();
            if (!status.stateIsValid) {
               lblDescription.text = "";
               updateLblTimeNeeded();
               updateLblScientistsNeeded();
               updateLblInsufficientScientists();
            }
            else {
               if (status.explorationIsUnderway) {
                  GlobalEvent.subscribe_TIMED_UPDATE(global_timedUpdateHandler);
                  lblDescription.text = getString("description.explorationUnderway");
               }
               else {
                  GlobalEvent.unsubscribe_TIMED_UPDATE(global_timedUpdateHandler);
                  if (!status.planetHasReasearchCenter)
                     lblDescription.text = getString("description.noResearchCenter");
                  else {
                     lblDescription.text = getString("description.startExploration");
                     updateLblTimeNeeded();
                     updateLblScientistsNeeded();
                     updateLblInsufficientScientists();
                  }
               }
            }
            updateLblInstantFinishCost();
            updateBtnBuyCredsVisibility();
            updateBtnInstantFinishVisibility();
         }
         if (f_timeLeftChanged || f_statusChanged)
            updateLblTimeLeft();
         
         f_statusChanged =
         f_timeLeftChanged = false;
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      [SkinPart(required="true")]
      public var pnlPanel:Panel;
      
      [SkinPart(required="true")]
      public var lblDescription:Label;
      
      [SkinPart(required="true")]
      public var warning:Warning;
      
      [SkinPart(required="true")]
      public var btnExplore:Button;
      private function updateBtnExplore() : void {
         if (btnExplore != null)
            btnExplore.enabled = status.stateIsValid && status.explorationCanBeStarted && !status.folliage.pending;
      }
      
      [SkinPart(required="true")]
      public var lblTimeLeft:Label;
      private function updateLblTimeLeft() : void {
         if (lblTimeLeft)
            lblTimeLeft.text = status.explorationIsUnderway ?
               getString("label.finishesIn", [DateUtil.secondsToHumanString(status.timeLeft)]) :
               "";
      }
      
      [SkinPart(required="true")]
      public var bmpClock:BitmapImage;
      
      [SkinPart(required="true")]
      public var lblTimeNeeded:ImageAndLabel;
      private function updateLblTimeNeeded() : void {
         if (lblTimeNeeded) {
            if (!status.stateIsValid)
               lblTimeNeeded.textToDisplay = "";
            else
               lblTimeNeeded.textToDisplay = DateUtil.secondsToHumanString(status.timeNeeded);
         }
      }
      
      [SkinPart(required="true")]
      public var lblScientistsNeeded:ImageAndLabel;
      private function updateLblScientistsNeeded() : void {
         if (lblScientistsNeeded) {
            if (!status.stateIsValid)
               lblScientistsNeeded.textToDisplay = "";
            else {
               lblScientistsNeeded.textToDisplay = status.scientistNeeded.toString();
               if (status.playerHasEnoughScientists)
                  lblScientistsNeeded.labelStyleName = null;
               else
                  lblScientistsNeeded.labelStyleName = "unsatisfied";
            }
         }
      }
      
      [SkinPart(required="true")]
      public var lblInsufficientScientists:Label;
      private function updateLblInsufficientScientists() : void {
         if (lblInsufficientScientists) {
            if (!status.stateIsValid)
               lblInsufficientScientists.visible =
               lblInsufficientScientists.includeInLayout = false;
            else
               lblInsufficientScientists.visible =
               lblInsufficientScientists.includeInLayout = !status.playerHasEnoughScientists;
         }
      }
      
      [SkinPart(required="true")]
      public var pnlInstantFinishPanel:Panel;
      
      [SkinPart(required="true")]
      public var lblInstantFinishCost:Label;
      private function updateLblInstantFinishCost() : void {
         if (lblInstantFinishCost != null)
            lblInstantFinishCost.text = getString("description.instantFinishCost", [status.instantFinishCost]);
      }
      
      [SkinPart(required="true")]
      public var btnInstantFinish:Button;
      private function updateBtnInstantFinishVisibility() : void {
         if (btnInstantFinish != null)
            btnInstantFinish.visible =
            btnInstantFinish.includeInLayout = status.canInstantFinish;
      }
      
      [SkinPart(required="true")]
      public var btnBuyCreds:Button;
      private function updateBtnBuyCredsVisibility() : void {
         if (btnBuyCreds != null)
            btnBuyCreds.visible = 
            btnBuyCreds.includeInLayout = !status.canInstantFinish;
      }
      
      
      protected override function partAdded(partName:String, instance:Object) : void {
         super.partAdded(partName, instance);
         switch (instance)
         {
            case warning:
               warning.text = Localizer.string("BuildingSidebar", "notYourPlanet");
               break;
            
            case lblScientistsNeeded:
               lblScientistsNeeded.type = ResourceType.SCIENTISTS;
               updateLblScientistsNeeded();
               break;
            
            case lblTimeNeeded:
               lblTimeNeeded.type = ResourceType.TIME;
               updateLblTimeNeeded();
               break;
            
            case lblTimeLeft:
               updateLblTimeLeft();
               break;
            
            case bmpClock:
               bmpClock.source = IMG.getImage(AssetNames.UI_IMAGES_FOLDER + 'exploration_clock')
               break;
            
            case pnlPanel:
               pnlPanel.title = getString("title.explore");
               break;
            
            case btnExplore:
               btnExplore.label = getString("label.explore");
               btnExplore.addEventListener(MouseEvent.CLICK, btnExplore_clickHandler, false, 0, true);
               updateBtnExplore();
               break;
            
            case lblInsufficientScientists:
               lblInsufficientScientists.text = Localizer.string("Technologies", "notEnoughScientistsExploration");
               lblInsufficientScientists.styleName = "unsatisfied";
               updateLblInsufficientScientists();
               break;
            
            case pnlInstantFinishPanel:
               pnlInstantFinishPanel.title = getString("title.instantFinish");
               break;
            
            case lblInstantFinishCost:
               updateLblInstantFinishCost();
               break;
            
            case btnInstantFinish:
               btnInstantFinish.label = "label.instantFinish";
               btnInstantFinish.addEventListener(MouseEvent.CLICK, btnInstantFinish_clickHandler, false, 0, true);
               updateBtnInstantFinishVisibility();
               break;
            
            case btnBuyCreds:
               btnBuyCreds.label = "label.buyCreds";
               btnBuyCreds.addEventListener(MouseEvent.CLICK, btnBuyCreds_clickHandler, false, 0, true);
               updateBtnBuyCredsVisibility();
               break;
         }
      }
      
      protected override function getCurrentSkinState() : String {
         if (status.explorationIsUnderway)     return "explorationUderway";
         if (!status.planetHasReasearchCenter) return "noResearchCenter";
         if (!status.planetBelongsToPlayer)    return "planetNotOwned";
         return "startExploration";
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      private function btnExplore_clickHandler(event:MouseEvent) : void {
         status.beginExploration();
      }
      
      private function btnBuyCreds_clickHandler(event:MouseEvent) : void {
         UrlNavigate.getInstance().showBuyCreds();
      }
      
      private function btnInstantFinish_clickHandler(event:MouseEvent) : void {
         status.finishInstantly();
      }
      
      
      /* ######################################## */
      /* ### ExplorationStatus EVENT HANDLERS ### */
      /* ######################################## */
      
      private function status_statusChangeHandler(event:ExplorationStatusEvent) : void {
         f_statusChanged = true;
         invalidateProperties();
         invalidateSkinState();
      }
      
      
      /* ############################ */
      /* ### TIMED_UPDATE HANDLER ### */
      /* ############################ */
      
      private function global_timedUpdateHandler(event:GlobalEvent) : void {
         f_timeLeftChanged = true;
         invalidateProperties();
      }
      
      
      /* ############### */
      /* ### HELPERS ### *
      /* ############### */
      
      private function getString(property:String, parameters:Array = null) : String {
         return Localizer.string("Exploration", property, parameters);
      }
   }
}