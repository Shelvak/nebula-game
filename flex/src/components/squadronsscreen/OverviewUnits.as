package components.squadronsscreen
{
   import mx.collections.ArrayCollection;
   
   import utils.SingletonFactory;

   public class OverviewUnits
   {
      public static function getInstance(): OverviewUnits
      {
         return SingletonFactory.getSingletonInstance(OverviewUnits);
      }
      
      public function getCachedUnits(status: int): ArrayCollection
      {
         
      }
   }
}