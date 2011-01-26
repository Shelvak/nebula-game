package components.map.space
{
   import components.gameobjects.solarsystem.SSObjectImage;
   
   import models.IMStaticSpaceObject;
   import models.solarsystem.MSSObject;
   
   import mx.events.PropertyChangeEvent;
   
   import spark.components.Label;
   import spark.primitives.BitmapImage;

   
   public class CSSObject extends CStaticSpaceObject
   {
      public function CSSObject()
      {
         super();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _staticObjectOld:MSSObject;
      public override function set staticObject(value:IMStaticSpaceObject) : void
      {
         if (super.staticObject != value)
         {
            if (!_staticObjectOld)
            {
               _staticObjectOld = MSSObject(value);
            }
            super.staticObject = value;
            f_staticObjectChanged = true;
            invalidateProperties();
         }
      }
      
      
      private var f_staticObjectChanged:Boolean = true,
                  f_ssObjectNameChanged:Boolean = true;
      
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_staticObjectChanged)
         {
            if (_staticObjectOld)
            {
               removeSSObjectEventHandlers(_staticObjectOld);
            }
            if (staticObject)
            {
               addSSObjectEventHandlers(MSSObject(staticObject));
            }
         }
         if (f_staticObjectChanged || f_ssObjectNameChanged)
         {
            if (staticObject)
            {
               lblName.text = MSSObject(staticObject).name;
            }
         }
         
         f_ssObjectNameChanged =
         f_staticObjectChanged = false;
      }
      
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      
      private var imgImage:SSObjectImage;
      private var lblName:Label;
      
      
      protected override function createChildren() : void
      {
         super.createChildren();
         
         var ssObject:MSSObject = MSSObject(staticObject);
         
         imgImage = new SSObjectImage();
         with (imgImage)
         {
            model            = ssObject;
            transformX       = this.width / 2;
            transformY       = this.height / 2;
            width            = this.width;
            height           = this.height;
            verticalCenter   = 0;
            horizontalCenter = 0;
            rotation         = ssObject.angle + 180
         }
         addElement(imgImage);
         
         lblName = new Label();
         with (lblName)
         {
            horizontalCenter = 0;
            bottom           = -16;
            text             = ssObject.name;
         }
         addElement(lblName);
      }
      
      
      /* ############################ */
      /* ### MODEL EVENT HANDLERS ### */
      /* ############################ */
      
      
      private function addSSObjectEventHandlers(ssObject:MSSObject) : void
      {
         ssObject.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ssObject_propertyChangeHandler,
                                   false, 0, true);
      }
      
      
      private function removeSSObjectEventHandlers(ssObject:MSSObject) : void
      {
         ssObject.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, ssObject_propertyChangeHandler,
                                      false);
      }
      
      
      private function ssObject_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         f_ssObjectNameChanged = true;
         invalidateProperties();
      }
   }
}