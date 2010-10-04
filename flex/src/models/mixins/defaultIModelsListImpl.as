public function findModel(id:int) : *
{
   return ModelsCollection.findModel(this, id);
}


public function findExactModel(model:BaseModel) : *
{
   return ModelsCollection.findExactModel(this, model);
}


/**
 * Adds the given model to this collection or updates a model already in the collection
 * (compared with <code>equals()</code> method).
 * 
 * @throws Error if <code>item</code> is not a <code>BaseModel</code>
 * 
 * @see mx.collections.ArrayCollection#addItemAt()
 */
public override function addItemAt(item:Object, index:int) : void
{
   checkItemType(item);
   var newModel:BaseModel = item as BaseModel;
   if (newModel.id == 0)
   {
      super.addItemAt(item, index);
      return;
   }
   var model:BaseModel = findExactModel(newModel);
   if (model)
   {
      model.copyProperties(newModel);
   }
   else
   {
      super.addItemAt(item, index);
   }
}


public function removeModelWithId(id:int) : *
{
   var model:BaseModel = findModel(id);
   if (model)
   {
      removeItem(findModel(id));
   }
   return model;
}


private function checkItemType(item:Object) : void
{
   if ( !(item is BaseModel) )
   {
      throw new Error(item + " is not an instance of BaseModel");
   }
}