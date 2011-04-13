package models.battle
{
   public class FireOrder
   {
      public function FireOrder(data:Object)
      {
         executorId = data[0][0];
         executorType = data[0][1];
         for each (var part:Array in data[1])
         {
            fireParts.push(new FireOrderPart(part));
         }
      }
      
      
      public var executorId:int;
      public var executorType:int;
      
      public var fireParts:Array = [];
   }
}