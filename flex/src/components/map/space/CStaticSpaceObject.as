package components.map.space
{
   import models.map.IMStaticSpaceObject;
   import models.location.LocationMinimal;
   
   import spark.components.Group;
   
   
   public class CStaticSpaceObject extends Group implements ICStaticSpaceObject
   {
      public function CStaticSpaceObject() {
         super();
      }
      
      private var _staticObject:IMStaticSpaceObject;
      public function set staticObject(value:IMStaticSpaceObject) : void {
         if (_staticObject != value) {
            _staticObject = value;
            if (_staticObject != null) {
               width  = _staticObject.componentWidth;
               height = _staticObject.componentHeight;
            }
            else {
               width = 0;
               height = 0;
            }
         }
      }
      public function get staticObject() : IMStaticSpaceObject {
         return _staticObject;
      }
      
      public function get currentLocation() : LocationMinimal {
         return _staticObject.currentLocation;
      }
      
      private var f_visibleChanged:Boolean = true;
      
      public override function set visible(value:Boolean) : void {
         if (super.visible != value) {
            super.visible = value;
            f_visibleChanged = true;
            invalidateProperties();
         }
      }
      
      protected override function commitProperties() : void {
         super.commitProperties();
         
         if (f_visibleChanged) {
            if (visible) {
               activate();
            }
            else {
               passivate();
            }
         }
         
         f_visibleChanged = true;
      }
      
      /**
       * Called when object becomes visible to activate it:
       * start animations, register event listeners etc. Override if necessary.
       */
      protected function activate() : void {
      }
      
      /**
       * Called when object becomes invisible again to passivate it:
       * stop animations, unregister event listeners etc. Override if necessary.
       */
      protected function passivate() : void {
      }
   }
}