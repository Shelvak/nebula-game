package models.movement
{
   import models.BaseModel;
   import models.location.ILocationUser;
   import models.location.Location;
   import models.location.LocationMinimal;
   
   public class MHop extends BaseModel implements ILocationUser
   {
      [Required]
      /**
       * Id of a route (id of a squadron actually) this hop is in.
       * <p><i><b>Metadata</b>: [Required]</i></p>
       * 
       * @default 0
       */
      public var routeId:int = 0;
      
      
      [Required]
      /**
       * Time when this squadron will reach hop's location.
       * <p><i><b>Metadata</b>: [Required]</i></p>
       * 
       * @default null
       */
      public var arrivesAt:Date = null;
      
      
      [Required]
      /**
       * Index which defines the place this hop takes in a route.
       * <p><i><b>Metadata</b>: [Required]</i></p>
       * 
       * @default -1
       */
      public var index:int = -1;
      
      
      [Required]
      /**
       * Location of this hop in space.
       * <p><i><b>Metadata</b>: [Required]</i></p>
       * 
       * @default null
       */
      public var location:LocationMinimal = null;
      
      
      /* ##################### */
      /* ### ILocationUser ### */
      /* ##################### */
      
      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function equals(o:Object) : Boolean {
         if (o is MHop) {
            var hop:MHop = MHop(o);
            return hop == this || hop.routeId == routeId && hop.location.equals(location);
         }
         return false;
      }
      
      public override function toString() : String {
         return "[" + "class: " + className + ", routeId: " + routeId + ", arrivesAt: " + arrivesAt +
                ", index: " + index + ", location: " + location + "]";
      }
   }
}