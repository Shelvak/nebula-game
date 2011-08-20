package tests.movement
{
   import models.BaseModel;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;

   public class TC_LocationMinimal
   {
      [Test(description="ensures equals() method compares tow MinimalLocation instance as it should")]
      public function equals() : void
      {
         var locationA:LocationMinimal = new LocationMinimal();
         var locationB:LocationMinimal = new LocationMinimal();
         
         // If we pass null or not an instance of LocationMinimal, should return false
         assertThat( locationA.equals(null), equalTo (false) );
         assertThat( locationA.equals(new BaseModel), equalTo (false) );
         
         // If we compare the same instance, they are always equal
         assertThat( locationA.equals(locationA), equalTo (true) );
         
         locationA.type = LocationType.GALAXY;
         locationA.x = 10;
         locationA.y = 10;
         
         // If both locations are of different type, they are not equal
         locationB.type = LocationType.SS_OBJECT;
         locationB.x = 10;
         locationB.y = 10;
         assertThat( locationA.equals(locationB), equalTo (false) );
         
         // If both locations are of same type but have different x and y values, they are not equal
         locationB.type = LocationType.GALAXY;
         locationB.x = 5;
         locationB.y = 10;
         assertThat( locationA.equals(locationB), equalTo (false) );
         locationB.x = 10;
         locationB.y = 5;
         assertThat( locationA.equals(locationB), equalTo (false) );
         
         // If id's of locations are different, locations are not equal
         locationA.x = locationB.x = 10;
         locationA.y = locationB.y = 10;
         locationA.id = 1;
         assertThat( locationA.equals(locationB), equalTo (false) );
         
         // Only if type, id, x and y are equal, locations are equal too
         locationB.id = 1;
         assertThat( locationA.equals(locationB), equalTo (true) );
      }
   }
}