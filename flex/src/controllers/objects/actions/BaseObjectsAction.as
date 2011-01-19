package controllers.objects.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.objects.ObjectClass;
   import controllers.objects.actions.customcontrollers.*;
   
   import flash.errors.IllegalOperationError;
   
   import utils.StringUtil;
   
   public class BaseObjectsAction extends CommunicationAction
   {
      protected static const CUSTOM_CONTROLLERS:Object = new Object();
      with (ObjectClass)
      {
         CUSTOM_CONTROLLERS[UNIT]                     = UnitController.getInstance();
         CUSTOM_CONTROLLERS[ROUTE]                    = RouteController.getInstance();
         CUSTOM_CONTROLLERS[WRECKAGE]                 = WreckageController.getInstance();
         CUSTOM_CONTROLLERS[SSOBJECT]                 = SSObjectController.getInstance();
         CUSTOM_CONTROLLERS[BUILDING]                 = BuildingController.getInstance();
         CUSTOM_CONTROLLERS[CLIENT_QUEST]             = ClientQuestController.getInstance();
         CUSTOM_CONTROLLERS[NOTIFICATION]             = NotificationController.getInstance();
         CUSTOM_CONTROLLERS[QUEST_PROGRESS]           = QuestProgressController.getInstance();
         CUSTOM_CONTROLLERS[OBJECTIVE_PROGRESS]       = ObjectiveProgressController.getInstance();
         CUSTOM_CONTROLLERS[CONSTRUCTION_QUEUE_ENTRY] = ConstructionQueueEntryController.getInstance();
         CUSTOM_CONTROLLERS[SS_METADATA]              = SSMetadataController.getInstance();
      }
      
      
      protected static function getCustomController(objectClass:String) : BaseObjectController
      {
         var controller:BaseObjectController = CUSTOM_CONTROLLERS[objectClass];
         if (!controller)
         {
            throw new Error("Object class " + objectClass +  " is not supported by objects|* actions");
         }
         return controller;
      }
      
      
      public function BaseObjectsAction()
      {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         for (var key:String in cmd.parameters[objectsHashName])
         {
            var className:Array = key.split('::');
            var objectClass:String = StringUtil.firstToLowerCase(className[0]);
            var objectSubclass:String = className.length > 1 ? className[1] : null;
            applyServerActionImpl(objectClass,
                                  objectSubclass,
                                  cmd.parameters.reason,
                                  cmd.parameters[objectsHashName][key]);
         }
      }
      
      
      /**
       * Name of the property that holds reference to objects hash. By default,
       * this is <code>"objects"</code>. 
       */
      protected function get objectsHashName() : String
      {
         return "objects";
      }
      
      
      protected function applyServerActionImpl(objectClass:String,
                                               objectSubclass:String,
                                               reason:String,
                                               objects:Array) : void
      {
         throw new IllegalOperationError("This method is abstract");
      }
   }
}