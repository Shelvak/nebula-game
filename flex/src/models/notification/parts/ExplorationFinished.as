package models.notification.parts
{
   import models.BaseModel;
   import models.Reward;
   import models.location.Location;
   import models.notification.INotificationPart;
   
   import utils.locale.Localizer;
   
   public class ExplorationFinished extends BaseModel implements INotificationPart
   {
      public function ExplorationFinished(params:Object = null)
      {
         super();
         if (params)
         {
            rewards = new Reward(params.rewards);
            location = BaseModel.createModel(Location, params.location);
         }
      }
      
      public function get title():String
      {
         return Localizer.string("Notifications", "title.explorationFinished", [location.planetName]);
      }
      
      public function get message():String
      {
         return Localizer.string("Notifications", "message.explorationFinished", [location.planetName]);
      }
      
      public var location:Location;
      public var rewards:Reward;
      
   }
}