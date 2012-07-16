package components.map.space.galaxy.entiregalaxy
{
   import com.developmentarc.core.utils.EventBroker;

   import components.base.viewport.ViewportZoomable;
   import components.map.BaseMapCoordsTransform;

   import flash.display.BitmapData;

   import flash.events.MouseEvent;
   import flash.geom.Point;

   import globalevents.GlobalEvent;

   import interfaces.ICleanable;

   import models.galaxy.FOWMatrix;
   import models.galaxy.MEntireGalaxy;

   import mx.graphics.BitmapFillMode;

   import spark.components.Group;
   import spark.primitives.BitmapImage;


   public class CEntireGalaxy extends Group implements ICleanable
   {
      public function CEntireGalaxy() {
         super();
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
         addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
      }

      private function global_appResetHandler(event: GlobalEvent): void {
         cleanup();
      }

      public function cleanup(): void {
         EventBroker.unsubscribe(GlobalEvent.APP_RESET, global_appResetHandler);
         removeEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
         removeAllElements();
      }

      private var _viewport: ViewportZoomable;
      public function set viewport(value: ViewportZoomable): void {
         _viewport = value;
      }

      private var _coordsTransform: BaseMapCoordsTransform;
      private var _model: MEntireGalaxy;
      public function set model(value: MEntireGalaxy): void {
         if (_model != value) {
            _model = value;
            f_modelChanged = true;
            invalidateProperties();
         }
      }

      private function get haveModel(): Boolean {
         return _model != null;
      }

      private var f_childrenCreated: Boolean = false;
      private var _image: BitmapImage;

      override protected function createChildren(): void {
         super.createChildren();
         if (f_childrenCreated) {
            return;
         }
         _image = new BitmapImage();
         _image.smooth = true;
         _image.fillMode = BitmapFillMode.REPEAT;
         _image.left = 0;
         _image.right = 0;
         _image.top = 0;
         _image.bottom = 0;
         addElement(_image);
         f_childrenCreated = true;
      }

      private var f_modelChanged: Boolean = true;

      override protected function commitProperties(): void {
         super.commitProperties();
         if (f_modelChanged) {
            if (haveModel) {
               const fowMatrix: FOWMatrix = _model.fowMatrix;
               _coordsTransform = new CoordsTransform(fowMatrix.getCoordsOffset());
               _coordsTransform.logicalWidth = fowMatrix.getBounds().width;
               _coordsTransform.logicalHeight = fowMatrix.getBounds().height;
               const bitmap: BitmapData = new EntireGalaxyRenderer(_model).bitmap;
               _image.source = bitmap
               width = bitmap.width;
               height = bitmap.height;
               const playerHome: MiniSS = _model.playerHomeSS;
               _viewport.moveContentTo(
                  _coordsTransform.logicalToReal(new Point(playerHome.x,  playerHome.y)));
            }
         }
         f_modelChanged = false;
      }

      private function this_mouseMoveHandler(event: MouseEvent): void {
         if (haveModel) {
            logicalMouseX = _coordsTransform.realToLogical_X(mouseX, mouseY);
            logicalMouseY = _coordsTransform.realToLogical_Y(mouseX, mouseY);
         }
      }

      [Bindable]
      public var logicalMouseX: int = 0;

      [Bindable]
      public var logicalMouseY: int = 0;
   }
}
