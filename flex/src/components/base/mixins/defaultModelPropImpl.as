// A public property "model" of BaseModel type is defined here using setter and getter.

import models.BaseModel;




private var _model:BaseModel = null;
[Bindable]
/**
 * This is a simple property implemented with setter and getter. When property changes
 * <code>invalidateProperties()</code> and <code>invalidateDisplayList()</code> methods are called.
 */
public function set model(v:BaseModel) : void
{
   if (_model != v)
   {
      _model = v;
      invalidateProperties();
      invalidateDisplayList();
   }
}
/**
 * @private
 */
public function get model() : BaseModel
{
   return _model;
}