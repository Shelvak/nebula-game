// Includes default model property implementation of IPrimitivePlanetMapObject
// as well as default implementation of initModel() method.


import flash.errors.IllegalOperationError;

import models.planet.MPlanetObject;



private var _model:MPlanetObject = null;
[Bindable("willNotChange")]
public function get model():MPlanetObject
{
   return _model;
}


private var fModelInitialized:Boolean = false;
public function initModel(model:MPlanetObject) : void
{
   if (fModelInitialized)
   {
      throw new IllegalOperationError("initModel() can only be called once!");
   }
   if (model == null)
   {
      throw new IllegalOperationError("model must not be null!");
   }
   _model = model;
   fModelInitialized = true;
   
   initProperties();
}