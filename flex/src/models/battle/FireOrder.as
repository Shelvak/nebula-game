package models.battle
{
   public class FireOrder
   {
      public function FireOrder(data:Object)
      {
         executorId = data[1][0];
         executorType = data[1][1];
         for each (var part:Array in data[2])
         {
            fireParts.push(new FireOrderPart(part));
         }
      }
      
      
      public var executorId:int;
      public var executorType:int;
      
      public var fireParts:Array = [];
   }
}