package components.foliage
{
   import components.base.ImageAndLabel;
   import components.base.Panel;
   import components.base.Warning;
   import components.foliage.skins.CExplorationPanelSkin;
   
   import flash.events.MouseEvent;
   
   import globalevents.GlobalEvent;
   
   import models.exploration.ExplorationStatus;
   import models.exploration.events.ExplorationStatusEvent;
   import models.resource.ResourceType;
   
   import spark.components.Button;
   import spark.components.Label;
   import spark.components.RichText;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.primitives.BitmapImage;
   import spark.utils.TextFlowUtil;
   
   import utils.DateUtil;
   import utils.UrlNavigate;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;
   
   
   [SkinState("startExploration")]
   [SkinState("noResearchCenter")]
   [SkinState("explorationUderway")]
   [SkinState("planetNotOwned")]
   public class CExplorationPanel extends SkinnableComponent
   {
      private function get IMG() : ImagePreloader {
         return ImagePreloader.getInstance();
      }
            
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      public function CExplorationPanel() {
         super();
         setStyle("skinClass", CExplorationPanelSkin);  
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private var _model:ExplorationStatus;
      public function set model(value:ExplorationStatus) : void {
         if (_model != value) {
            if (_model != null)
               _model.removeEventListener(ExplorationStatusEvent.STATUS_CHANGE, panelModel_statusChangeHandler, false);
            _model = value;
            if (_model != null)
               _model.addEventListener(ExplorationStatusEvent.STATUS_CHANGE, panelModel_statusChangeHandler);
            f_statusChanged = true;
            f_timeLeftChanged = true;
            invalidateProperties();
         }
      }
      public function get model() : ExplorationStatus {
         return _model;
      }
      
      
      private var f_statusChanged:Boolean = true,
                  f_timeLeftChanged:Boolean = true;
      
      protected override function commitProperties() : void {
         super.commitProperties();
         
         if (_model == null) return;
         
         if (f_statusChanged) {
            updateBtnExplore();
            if (!_model.stateIsValid) {
               lblDescription.text = "";
               updateLblTimeNeeded();
               updateLblScientistsNeeded();
               updateLblInsufficientScientists();
            }
            else {
               if (_model.explorationIsUnderway) {
                  GlobalEvent.subscribe_TIMED_UPDATE(global_timedUpdateHandler);
                  lblDescription.text = getString("description.explorationUnderway");
               }
               else {
                  GlobalEvent.unsubscribe_TIMED_UPDATE(global_timedUpdateHandler);
                  if (!_model.planetHasReasearchCenter)
                     lblDescription.text = getString("description.noResearchCenter");
                  else {
                     lblDescription.text = getString("description.startExploration");
                     updateLblTimeNeeded();
                     updateLblScientistsNeeded();
                     updateLblInsufficientScientists();
                  }
               }
            }
            updateTxtInstantFinishCost();
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
            btnExplore.enabled = _model.stateIsValid &&
                                 _model.explorationCanBeStarted &&
                                !_model.foliage.pending;
      }
      
      [SkinPart(required="true")]
      public var lblTimeLeft:Label;
      private function updateLblTimeLeft() : void {
         if (lblTimeLeft)
            lblTimeLeft.text = _model.explorationIsUnderway ?
               getString("label.finishesIn", [DateUtil.secondsToHumanString(_model.timeLeft)]) :
               "";
      }
      
      [SkinPart(required="true")]
      public var bmpClock:BitmapImage;
      
      [SkinPart(required="true")]
      public var lblTimeNeeded:ImageAndLabel;
      private function updateLblTimeNeeded() : void {
         if (lblTimeNeeded) {
            if (!_model.stateIsValid)
               lblTimeNeeded.textToDisplay = "";
            else
               lblTimeNeeded.textToDisplay = DateUtil.secondsToHumanString(_model.timeNeeded);
         }
      }
      
      [SkinPart(required="true")]
      public var lblScientistsNeeded:ImageAndLabel;
      private function updateLblScientistsNeeded() : void {
         if (lblScientistsNeeded) {
            if (!_model.stateIsValid)
               lblScientistsNeeded.textToDisplay = "";
            else {
               lblScientistsNeeded.textToDisplay = _model.scientistNeeded.toString();
               if (_model.playerHasEnoughScientists)
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
            if (!_model.stateIsValid)
               lblInsufficientScientists.visible =
               lblInsufficientScientists.includeInLayout = false;
            else
               lblInsufficientScientists.visible =
               lblInsufficientScientists.includeInLayout = !_model.playerHasEnoughScientists;
         }
      }
      
      [SkinPart(required="true")]
      public var pnlInstantFinishPanel:Panel;
      
      [SkinPart(required="true")]
      public var txtInstantFinishCost:RichText;
      private function updateTxtInstantFinishCost() : void {
         if (txtInstantFinishCost != null)
            txtInstantFinishCost.textFlow = TextFlowUtil.importFromString(getString("description.instantFinishCost", [_model.instantFinishCost]));
      }
      
      [SkinPart(required="true")]
      public var btnInstantFinish:Button;
      private function updateBtnInstantFinishVisibility() : void {
         if (btnInstantFinish != null)
            btnInstantFinish.visible =
            btnInstantFinish.includeInLayout = _model.canInstantFinish;
      }
      
      [SkinPart(required="true")]
      public var btnBuyCreds:Button;
      private function updateBtnBuyCredsVisibility() : void {
         if (btnBuyCreds != null)
            btnBuyCreds.visible = 
            btnBuyCreds.includeInLayout = !_model.canInstantFinish;
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
            
            case txtInstantFinishCost:
               updateTxtInstantFinishCost();
               break;
            
            case btnInstantFinish:
               btnInstantFinish.label = getString("label.instantFinish");
               btnInstantFinish.addEventListener(MouseEvent.CLICK, btnInstantFinish_clickHandler, false, 0, true);
               updateBtnInstantFinishVisibility();
               break;
            
            case btnBuyCreds:
               btnBuyCreds.label = getString("label.buyCreds");
               btnBuyCreds.addEventListener(MouseEvent.CLICK, btnBuyCreds_clickHandler, false, 0, true);
               updateBtnBuyCredsVisibility();
               break;
         }
      }
      
      protected override function getCurrentSkinState() : String {
         if ( _model.explorationIsUnderway)    return "explorationUderway";
         if (!_model.planetHasReasearchCenter) return "noResearchCenter";
         if (!_model.planetBelongsToPlayer)    return "planetNotOwned";
         return "startExploration";
      }
      
      
      /* ################################# */
      /* ### SKIN PARTS EVENT HANDLERS ### */
      /* ################################# */
      
      private function btnExplore_clickHandler(event:MouseEvent) : void {
         _model.beginExploration();
      }
      
      private function btnBuyCreds_clickHandler(event:MouseEvent) : void {
         UrlNavigate.getInstance().showBuyCreds();
      }
      
      private function btnInstantFinish_clickHandler(event:MouseEvent) : void {
         _model.finishInstantly();
      }
      
      
      /* ######################################## */
      /* ### ExplorationStatus EVENT HANDLERS ### */
      /* ######################################## */
      
      private function panelModel_statusChangeHandler(event:ExplorationStatusEvent) : void {
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