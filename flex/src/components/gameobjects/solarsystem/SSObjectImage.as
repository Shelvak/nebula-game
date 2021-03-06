package components.gameobjects.solarsystem
{
   import components.base.BaseSkinnableComponent;
   import components.gameobjects.skins.SSObjectImageSkin;
   
   import models.BaseModel;
   import models.Owner;
   import models.solarsystem.MSSObject;
   
   import mx.events.PropertyChangeEvent;
   import mx.graphics.BitmapFillMode;
   
   import spark.primitives.BitmapImage;
   
   
   [SkinState("neutral")]
   [SkinState("player")]
   [SkinState("ally")]
   [SkinState("nap")]
   [SkinState("enemy")]
   public class SSObjectImage extends BaseSkinnableComponent
   {
      /**
       * Constructor.
       */
      public function SSObjectImage() {
         super();
         setStyle("skinClass", SSObjectImageSkin);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private var _oldModel:MSSObject = null;
      public override function set model(v:BaseModel) : void {
         if (model != v) {
            if (_oldModel == null) {
               _oldModel = getSSObject();
            }
            super.model = v;
            fModelChanged = true;
            invalidateProperties();
            invalidateSkinState();
         }
      }
      
      
      /**
       * Type getter for <code>model</code> property.
       */
      public function getSSObject() : MSSObject {
         return MSSObject(model);
      }
      
      private var fModelChanged:Boolean = false;
      protected override function commitProperties() : void {
         super.commitProperties();
         
         if (fModelChanged) {
            if (_oldModel != null) {
               removeSSObjectEventHandlers(_oldModel);
               _oldModel = null;
            }
            image.source = null;
            if (model != null) {
               addSSObjectEventHandlers(getSSObject());
               image.source = getSSObject().imageData;
            }
         }
         
         fModelChanged = false;
      }
      
      
      /* ############ */
      /* ### SIZE ### */
      /* ############ */
      
      
      protected override function measure() : void
      {
         measuredWidth = MSSObject.IMAGE_WIDTH;
         measuredHeight = MSSObject.IMAGE_HEIGHT;
      }
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      /**
       * Image for displaying planet picture.
       */
      public var image:BitmapImage;
      
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName, instance);
         if (instance == image)
         {
            image.smooth = true;
            image.fillMode = BitmapFillMode.SCALE;
         }
      }
      
      
      override protected function getCurrentSkinState() : String
      {
         if (!model)
         {
            return "neutral";
         }
         switch(getSSObject().owner)
         {
            case Owner.PLAYER: return "player";
            case Owner.ALLY: return "ally";
            case Owner.NAP: return "nap";
            case Owner.ENEMY: return "enemy";
            default: return "neutral";
         }
      }
      
      
      /* ############################# */
      /* ### PLANET EVENT HANDLERS ### */
      /* ############################# */
      
      
      private function addSSObjectEventHandlers(object:MSSObject) : void
      {
         object.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ssObject_propertyChangeHandler);
      }
      
      
      private function removeSSObjectEventHandlers(object:MSSObject) : void
      {
         object.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ssObject_propertyChangeHandler);
      }
      
      
      private function ssObject_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         invalidateSkinState();
      }
   }
}