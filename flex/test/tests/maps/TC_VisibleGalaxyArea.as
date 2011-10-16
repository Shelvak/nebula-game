package tests.maps
{
   import models.galaxy.Galaxy;
   import models.galaxy.VisibleGalaxyArea;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.emptyArray;

   public class TC_VisibleGalaxyArea
   {
      private var galaxy:Galaxy;
      private var area:VisibleGalaxyArea;
      
      [Before]
      public function setUp() : void {
         galaxy = new Galaxy();
         area = new VisibleGalaxyArea(galaxy);
      }
      
      [After]
      public function tearDown() : void {
         galaxy = null;
         area = null;
      }
      
      
      /* ############# */
      /* ### TESTS ### */
      /* ############# */
      
      [Test]
      public function initialGalaxyIsEmpty() : void {
         assertThat( "visibleObjects", new VisibleGalaxyArea(galaxy).visibleObjects, emptyArray() );
      }
      
      [Test]
   }
}