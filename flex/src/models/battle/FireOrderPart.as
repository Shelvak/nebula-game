package models.battle
{
   public class FireOrderPart
   {
      public function FireOrderPart(data:Array)
      {
         gunId = data[0];
         
         targetId = data[1][0];
         targetType = data[1][1];
         
         damage = data[2];
      }
      
      
      public var gunId:int;
      public var targetId:int;
      public var targetType:int;
      public var missed:Boolean;
      public var damage:int;
   }
}