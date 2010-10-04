package tests._old.models
{
   import models.Galaxy;
   import models.solarsystem.SolarSystem;
   
   import namespaces.client_internal;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   
   
   
   public class GalaxyTest extends TestCase
   {
      private var galaxy: Galaxy;
      
      
      override protected function setUp () :void
      {
         galaxy = new Galaxy ();
      }
      
      
      [Test]
      public function width () :void
      {
         galaxy.minX = 0;
         galaxy.maxX = 9;
         assertEquals ("Width should be 10 tiles.", 10, galaxy.width);
         
         galaxy.minX = -5;
         galaxy.maxX =  5;
         assertEquals ("Width should be 11 tiles.", 11, galaxy.width);
         
         galaxy.minX = -15;
         galaxy.maxX = -10;
         assertEquals ("Width should be 6 tiles.", 6, galaxy.width);
      }
      
      
      [Test]
      public function height () :void
      {
         galaxy.minY = 0;
         galaxy.maxY = 9;
         assertEquals ("Height should be 10 tiles.", 10, galaxy.height);
         
         galaxy.minY = -5;
         galaxy.maxY =  5;
         assertEquals ("Height should be 11 tiles.", 11, galaxy.height);
         
         galaxy.minY = -15;
         galaxy.maxY = -10;
         assertEquals ("Height should be 6 tiles.", 6, galaxy.height);
      }
      
      
      [Test]
      public function xOffset () :void
      {
         galaxy.minX = 5;
         assertEquals ("xOffset should be -5", -5, galaxy.xOffset);
         
         galaxy.minX = 0;
         assertEquals ("xOffset should be -5", 0, galaxy.xOffset);
         
         galaxy.minX = -5;
         assertEquals ("xOffset should be -5", 5, galaxy.xOffset);
      }
      
      
      [Test]
      public function yOffset () :void
      {
         galaxy.minY = 5;
         assertEquals ("xOffset should be -5", -5, galaxy.yOffset);
         
         galaxy.minY = 0;
         assertEquals ("xOffset should be -5", 0, galaxy.yOffset);
         
         galaxy.minY = -5;
         assertEquals ("xOffset should be -5", 5, galaxy.yOffset);
      }
      
      
	   [Test]
      public function setMinMaxOnDefaultGalaxy () :void
      {
         galaxy.client_internal::setMinMaxProperties ();
         assertEquals ("minX should be set to default (0)", 0, galaxy.minX);
         assertEquals ("minY should be set to default (0)", 0, galaxy.minY);
         assertEquals ("maxX should be set to default (0)", 0, galaxy.maxX);
         assertEquals ("maxY should be set to default (0)", 0, galaxy.maxY);
      }
      
      
      
      // All galaxies are in the first quater of a coordinate system
      [Test]
      public function setMinMaxFirstQuater () :void
      {
         createSSInGalaxy (5, 7);
         createSSInGalaxy (10, 29);
         createSSInGalaxy (1, 100);
         
         galaxy.client_internal::setMinMaxProperties ();
         
         assertEquals ("minX should be 1", 1, galaxy.minX);
         assertEquals ("minY shoule be 7", 7, galaxy.minY);
         assertEquals ("maxX should be 10", 10, galaxy.maxX);
         assertEquals ("maxY should be 100", 100, galaxy.maxY);
      }
      
      
      // All galaxies are in the second quater of a coordinate system
      [Test]
      public function setMinMaxSecondQuarter () :void
      {
         createSSInGalaxy (-5, 7);
         createSSInGalaxy (-10, 29);
         createSSInGalaxy (-1, 100);
         
         galaxy.client_internal::setMinMaxProperties ();
         
         assertEquals ("minX should be -10", -10, galaxy.minX);
         assertEquals ("minY should be 7", 7, galaxy.minY);
         assertEquals ("maxX should be -1", -1, galaxy.maxX);
         assertEquals ("maxY should be 100", 100, galaxy.maxY);
      }
      
      
      // All galaxies are in the third quater of a coordinate system
      [Test]
      public function setMinMaxThirdQuarter () :void
      {
         createSSInGalaxy (-5, -7);
         createSSInGalaxy (-10, -29);
         createSSInGalaxy (-1, -100);
         
         galaxy.client_internal::setMinMaxProperties ();
         
         assertEquals ("minX should be -10", -10, galaxy.minX);
         assertEquals ("minY should be -100", -100, galaxy.minY);
         assertEquals ("maxX should be -1", -1, galaxy.maxX);
         assertEquals ("maxY should be -7", -7, galaxy.maxY);
      }
      
      
      // All galaxies are in the fourth quater of a coordinate system
      [Test]
      public function setMinMaxFourthQuarter () :void
      {
         createSSInGalaxy (5, -7);
         createSSInGalaxy (10, -29);
         createSSInGalaxy (1, -100);
         
         galaxy.client_internal::setMinMaxProperties ();
         
         assertEquals ("minX should be 1", 1, galaxy.minX);
         assertEquals ("minY should be -100", -100, galaxy.minY);
         assertEquals ("maxX should be 10", 10, galaxy.maxX);
         assertEquals ("maxY should be -7", -7, galaxy.maxY);
      }
      
      
      // All galaxies are in all four quaters of a coordinate system
      [Test]
      public function setMinMaxMix () :void
      {
         createSSInGalaxy (0, 0);
         createSSInGalaxy (10, 20);
         createSSInGalaxy (-5, 7);
         createSSInGalaxy (-9, -58);
         createSSInGalaxy (12, -9);
         
         galaxy.client_internal::setMinMaxProperties ();
         
         assertEquals ("minX should be -9", -9, galaxy.minX);
         assertEquals ("minY should be -58", -58, galaxy.minY);
         assertEquals ("maxX should be 12", 12, galaxy.maxX);
         assertEquals ("maxY should be 20", 20, galaxy.maxY);
      }
      
      
      private function createSSInGalaxy (x: Number, y: Number) :SolarSystem
      {
         var ss: SolarSystem = new SolarSystem ();
         
         ss.x = x;
         ss.y = y;
         galaxy.addSolarSystem (ss);
         
         return ss;
      }
   }
}