package tests.maps
{
   import components.base.viewport.IVisibleAreaTrackerClient;
   
   import flash.geom.Rectangle;
   
   
   internal class VisibleAreaTrackerClientMock implements IVisibleAreaTrackerClient
   {
      public var visibleAreaChangeCalls:int;
      public var visibleAreaChangeParams:VisibleAreaChangeParams;
      
      public function VisibleAreaTrackerClientMock() {
      }
      
      public function visibleAreaChange(visibleArea:Rectangle,
                                        areasHidden:Vector.<Rectangle>,
                                        areasShown:Vector.<Rectangle>) : void {
         visibleAreaChangeCalls++;
         visibleAreaChangeParams = new VisibleAreaChangeParams(
            visibleArea,
            areasHidden,
            areasShown
         );
      }
      
      public function clear() : void {
         visibleAreaChangeCalls = 0;
         visibleAreaChangeParams = null;
      }
   }
}