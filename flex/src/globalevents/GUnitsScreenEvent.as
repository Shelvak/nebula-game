package globalevents
{
   import models.resource.Resource;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   public class GUnitsScreenEvent extends GlobalEvent
   {
      public static const FACILITY_OPEN: String = "facilityOpen";
      public static const OPEN_STORAGE_SCREEN: String = "openStorageScreen";
      
      public var facilityId: int;
      
      public var unitsCollection: ListCollectionView;
      
      public var destination: *;
      
      public var location: *;
      
      public function GUnitsScreenEvent(type:String, params: * = null, eagerDispatch:Boolean=true)
      {
         switch (type)
         {
            case (FACILITY_OPEN):
               facilityId = params;
               break;
            case (OPEN_STORAGE_SCREEN):
               location = params.location;
               destination = params.oldLocation;
               unitsCollection = params.oldUnits;
               break;
         }
         super(type, eagerDispatch);
      }
   }
}