package controllers.objects.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.objects.ObjectClass;
   import controllers.screens.MainAreaScreens;
   import controllers.screens.MainAreaScreensSwitch;
   import controllers.ui.NavigationController;
   
   import globalevents.GObjectEvent;
   
   import models.BaseModel;
   import models.building.Building;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.factories.BuildingFactory;
   import models.factories.ConstructionQueryEntryFactory;
   import models.factories.QuestFactory;
   import models.factories.UnitFactory;
   import models.notification.Notification;
   import models.planet.Planet;
   import models.planet.PlanetObject;
   import models.quest.Quest;
   import models.quest.events.QuestEvent;
   import models.unit.Unit;
   
   import utils.ClassUtil;
   import utils.StringUtil;
   
   /**
    * is received for every object that was created 
    * @author Jho
    * 
    */   
   public class CreatedAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var className:Array = String(cmd.parameters.className).split('::');
         var objectClass:String = StringUtil.firstToLowerCase(className[0]);
         var objectSubclass:String = className.length > 1 ? className[1] : null;
         var objects: Array = cmd.parameters.objects;
         var reason:String = cmd.parameters.reason;
         for each (var object: Object in objects)
         {
            switch (objectClass)
            {
               case ObjectClass.UNIT:
                  var tempUnit:Unit = UnitFactory.fromObject(object);
                  if (tempUnit.lastUpdate != null)
                  {
                     tempUnit.upgradePart.startUpgrade();
                  }
                  ML.units.addItem(tempUnit); 
                  break;
               
               case ObjectClass.BUILDING:
                  if (object != null)
                  {
                     var tempBuilding:Building = BuildingFactory.fromObject(object);
                     if (ML.latestPlanet && ML.latestPlanet.id == tempBuilding.planetId)
                     {
                        var objectOnPoint: PlanetObject = ML.latestPlanet.getObject(tempBuilding.x, tempBuilding.y);
                        if (objectOnPoint != null && objectOnPoint is Building)
                        {
                           var ghost: Building = objectOnPoint as Building;
                           ghost.copyProperties(tempBuilding);
                           ghost.upgradePart.startUpgrade();
                        }
                        else
                        {
                           ML.latestPlanet.build(tempBuilding);
                           tempBuilding.upgradePart.startUpgrade();
                        } 
                     }
                  }
                  break;
               
               case ObjectClass.CLIENT_QUEST:
                  var quest: Quest = QuestFactory.fromObject(object);
                  ML.quests.addItem(quest);
                  quest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
                  break;
               
               case ObjectClass.CONSTRUCTION_QUEUE_ENTRY:
                  var tempQuery:ConstructionQueueEntry = ConstructionQueryEntryFactory.fromObject(object);
                  var constructor: Building = ML.latestPlanet.getBuildingById(tempQuery.constructorId);
                  constructor.constructionQueueEntries.addItemAt(tempQuery, tempQuery.position); 
                  constructor.dispatchQueryChangeEvent();
                  if (StringUtil.firstToLowerCase(tempQuery.constructableType.split('::')[0]) == ObjectClass.BUILDING)
                  {
                     ML.latestPlanet.buildGhost(
                        ClassUtil.toSimpleClassName(tempQuery.constructableType),
                        tempQuery.params.x,
                        tempQuery.params.y,
                        constructor.id
                     );
                  }
                  break;
               
               case ObjectClass.NOTIFICATION:
                  var notification:Notification = BaseModel.createModel(Notification, object);
                  notification.isNew = true;
                  ML.notifications.addItem(notification);
                  if (MainAreaScreensSwitch.getInstance().currentScreenName != MainAreaScreens.NOTIFICATIONS)
                  {
                     ML.notificationAlerts.addItem(notification);
                  }
                  var planet:Planet = ML.latestPlanet;
                  if (notification.event == 0 && planet != null)
                  {
                     for each (var coords:Array in object.params.coordinates)
                     {
                        var remove:PlanetObject = planet.getObject(coords[0], coords[1]);
                        planet.removeObject(remove);
                     }
                  }
                  break;
               
               default:
                  throw new Error("object class "+objectClass+" not found!");
                  break;
            }
            new GObjectEvent(GObjectEvent.OBJECT_APROVED);
         }
      }
   }
}