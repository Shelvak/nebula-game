package models.galaxy
{
   import models.location.LocationMinimal;


   public class FOWBorderElement
   {
      public function FOWBorderElement(
         location: LocationMinimal, left: Boolean = false, right: Boolean = false,
         top: Boolean = false, bottom:Boolean = false)
      {
         this.location = location;
         this.left = left;
         this.right = right;
         this.top = top;
         this.bottom = bottom;
      }

      public var location: LocationMinimal;
      public var left: Boolean;
      public var right: Boolean;
      public var top: Boolean;
      public var bottom: Boolean;
   }
}
