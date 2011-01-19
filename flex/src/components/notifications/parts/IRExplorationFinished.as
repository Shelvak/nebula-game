package components.notifications.parts
{
   import components.base.ImageAndLabel;
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.ExplorationFinishedSkin;
   
   import models.notification.parts.ExplorationFinished;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.DataGroup;
   import spark.components.Group;
   import spark.components.Label;
   
   
   public class IRExplorationFinished extends IRNotificationPartBase
   {
      public function IRExplorationFinished()
      {
         super();
         setStyle("skinClass", ExplorationFinishedSkin);
      };
      
      
      [SkinPart(required="true")]
      public var location:MiniLocationComp;
      
      
      [SkinPart(required="true")]
      public var unitsGroup:DataGroup;
      
      
      [SkinPart(required="true")]
      public var message:Label;
      
      [SkinPart(required="true")]
      public var metalIL:ImageAndLabel;
      
      [SkinPart(required="true")]
      public var energyIL:ImageAndLabel;
      
      [SkinPart(required="true")]
      public var zetiumIL:ImageAndLabel;
      
      [SkinPart(required="true")]
      public var pointsLbl:Label;
      
      [SkinPart(required="true")]
      public var unitsCont: Group;
      
      [SkinPart(required="true")]
      public var pointsGroup: Group;
      
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (fNotificationPartChange)
         {
            var part:ExplorationFinished = ExplorationFinished(notificationPart);
            unitsGroup.dataProvider = new ArrayCollection(part.rewards.units);
            location.location = part.location;
            message.text = part.message;
            metalIL.textToDisplay = part.rewards.metal.toString();
            energyIL.textToDisplay = part.rewards.energy.toString();
            zetiumIL.textToDisplay = part.rewards.zetium.toString();
            pointsLbl.text = part.rewards.points.toString();
            unitsCont.visible = (part.rewards.units.length > 0);
            pointsGroup.visible = (part.rewards.points != 0);
         }
         fNotificationPartChange = false;
      }
   }
}