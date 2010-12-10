package models.notification.parts
{
   import models.BaseModel;
   import models.Reward;
   import models.location.Location;
   import models.notification.INotificationPart;
   
   public class ExplorationFinished extends BaseModel implements INotificationPart
   {
      public function ExplorationFinished(params:Object = null)
      {
         super();
         if (params)
         {
            
         }
      }
      
      public function get title():String
      {
         return null;
      }
      
      public function get message():String
      {
         return null;
      }
   }
   
   
   public var location:Location;
   public var rewards:Reward;
}