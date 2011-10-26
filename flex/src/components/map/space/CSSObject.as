package components.map.space
{
   import components.gameobjects.solarsystem.SSObjectImage;
   
   import models.map.IMStaticSpaceObject;
   import models.solarsystem.MSSObject;
   
   import mx.events.PropertyChangeEvent;
   
   import spark.components.Label;

   
   public class CSSObject extends CStaticSpaceObject
   {
      public function CSSObject() {
         super();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private var _staticObjectOld:MSSObject;
      public override function set staticObject(value:IMStaticSpaceObject) : void {
         if (super.staticObject != value) {
            if (_staticObjectOld == null) {
               _staticObjectOld = MSSObject(value);
            }
            super.staticObject = value;
            f_staticObjectChanged = true;
            invalidateProperties();
         }
      }
      
      private var f_staticObjectChanged:Boolean = true;
      private var f_ssObjectNameChanged:Boolean = true;
      
      protected override function commitProperties() : void {
         super.commitProperties();
         
         var ssObject:MSSObject = MSSObject(staticObject);
         if (f_staticObjectChanged) {
            if (_staticObjectOld != null) {
               MSSObject(_staticObjectOld).removeEventListener(
                  PropertyChangeEvent.PROPERTY_CHANGE,
                  ssObject_propertyChangeHandler, false
               );
               _staticObjectOld = null;
            }
            if (ssObject != null) {
               ssObject.addEventListener(
                  PropertyChangeEvent.PROPERTY_CHANGE,
                  ssObject_propertyChangeHandler, false, 0, true
               );
               imgImage.transformX = width / 2;
               imgImage.transformY = height / 2;
               imgImage.width = width;
               imgImage.height = height;
               imgImage.model = ssObject;
               imgImage.rotation = ssObject.angle + 180
            }
         }
         if (f_staticObjectChanged || f_ssObjectNameChanged) {
            if (ssObject != null) {
               lblName.text = ssObject.name;
            }
         }
         
         f_ssObjectNameChanged = false;
         f_staticObjectChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      private var imgImage:SSObjectImage;
      private var lblName:Label;
      
      protected override function createChildren() : void {
         super.createChildren();
         
         imgImage = new SSObjectImage();
         imgImage.verticalCenter = 0;
         imgImage.horizontalCenter = 0;
         addElement(imgImage);
         
         lblName = new Label();
         lblName.horizontalCenter = 0;
         lblName.bottom = -16;
         addElement(lblName);
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      private function ssObject_propertyChangeHandler(event:PropertyChangeEvent) : void {
         f_ssObjectNameChanged = true;
         invalidateProperties();
      }
   }
}