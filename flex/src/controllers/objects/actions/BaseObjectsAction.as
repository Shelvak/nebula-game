package controllers.objects.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.objects.ObjectClass;
   import controllers.objects.actions.customcontrollers.*;
   
   import flash.errors.IllegalOperationError;
   
   import utils.ModelUtil;
   
   
   public class BaseObjectsAction extends CommunicationAction
   {
      protected static const CUSTOM_CONTROLLERS:Object = new Object();
      with (ObjectClass) {
         CUSTOM_CONTROLLERS[UNIT]                     = UnitController.getInstance();
         CUSTOM_CONTROLLERS[ROUTE]                    = new RouteController();
         CUSTOM_CONTROLLERS[WRECKAGE]                 = new WreckageController();
         CUSTOM_CONTROLLERS[SSOBJECT]                 = new SSObjectController();
         CUSTOM_CONTROLLERS[BUILDING]                 = new BuildingController();
         CUSTOM_CONTROLLERS[CLIENT_QUEST]             = new ClientQuestController();
         CUSTOM_CONTROLLERS[NOTIFICATION]             = new NotificationController();
         CUSTOM_CONTROLLERS[QUEST_PROGRESS]           = new QuestProgressController();
         CUSTOM_CONTROLLERS[OBJECTIVE_PROGRESS]       = new ObjectiveProgressController();
         CUSTOM_CONTROLLERS[CONSTRUCTION_QUEUE_ENTRY] = new ConstructionQueueEntryController();
         CUSTOM_CONTROLLERS[SS_METADATA]              = new SSMetadataController();
         CUSTOM_CONTROLLERS[COOLDOWN]                 = new CooldownController();
         CUSTOM_CONTROLLERS[SOLAR_SYSTEM]             = new SolarSystemController();
         CUSTOM_CONTROLLERS[TILE]                     = new TileController();
      }
      
      
      protected static function getCustomController(objectClass:String) : BaseObjectController {
         var controller:BaseObjectController = CUSTOM_CONTROLLERS[objectClass];
         if (controller == null)
            throw new Error("Object class " + objectClass +  " is not supported by objects|* actions");
         return controller;
      }
      
      
      public function BaseObjectsAction() {
         super();
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         for (var type:String in cmd.parameters[objectsHashName]) {
            var objectClass:String = ModelUtil.getModelClass(type);
            var objectSubclass:String = ModelUtil.getModelSubclass(type, false);
            applyServerActionImpl(objectClass,
                                  objectSubclass,
                                  cmd.parameters.reason,
                                  cmd.parameters[objectsHashName][type]);
         }
      }
      
      /**
       * Name of the property that holds reference to objects hash. By default,
       * this is <code>"objects"</code>. 
       */
      protected function get objectsHashName() : String {
         return "objects";
      }
      
      protected function applyServerActionImpl(objectClass:String,
                                               objectSubclass:String,
                                               reason:String,
                                               objects:Array) : void {
         throw new IllegalOperationError("This method is abstract");
      }
   }
}