package controllers.objects.actions
{
   /**
    *is received after battle for every unit that was updated 
    * @author Jho
    * 
    */
   public class UpdatedAction extends BaseObjectsAction
   {
      override protected function applyServerActionImpl(objectClass:String,
                                                        objectSubclass:String,
                                                        reason:String,
                                                        parameters:Object):void
      {
         ML.units.disableAutoUpdate();
         for each (var object:Object in parameters.objects)
         {
            getCustomController(objectClass).objectUpdated(objectSubclass, object, reason);
         }
         ML.units.enableAutoUpdate();
      }
   }
}