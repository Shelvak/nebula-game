package tests.maps
{
   import flash.geom.Rectangle;
   
   
   internal class VisibleAreaChangeParams
   {
      public var visibleArea:Rectangle;
      public var areasHidden:Vector.<Rectangle>;
      public var areasShown:Vector.<Rectangle>;
      
      public function VisibleAreaChangeParams(visibleArea:Rectangle,
                                              areasHidden:Vector.<Rectangle>,
                                              areasShown:Vector.<Rectangle>) {
         this.visibleArea = visibleArea;
         this.areasHidden = areasHidden;
         this.areasShown = areasShown;
      }
   }
}