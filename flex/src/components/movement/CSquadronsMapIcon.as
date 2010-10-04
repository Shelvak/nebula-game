package components.movement
{
   import components.map.space.IMapSpaceObject;
   
   import models.IModelsList;
   import models.ModelsCollection;
   import models.ModelsCollectionSlave;
   import models.Owner;
   import models.location.LocationMinimal;
   import models.movement.MSquadron;
   
   import spark.components.Group;
   
   import utils.ClassUtil;
   
   
   /**
    * Used as indicator of a few squadrons owned by the same owner group (player, alliance, NAP and
    * enemy) in the same sector
    */
   public class CSquadronsMapIcon extends Group implements IMapSpaceObject
   {
      /**
       * Width of the component.
       */
      public static const WIDTH:Number = 16;
      /**
       * Height of the component.
       */
      public static const HEIGHT:Number = WIDTH;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function CSquadronsMapIcon()
      {
         super();
         width = WIDTH;
         height = HEIGHT;
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void
      {
         super.updateDisplayList(uw, uh);
         var fillColor:uint = 0xFF00FF;
         graphics.clear();
         switch (squadronsOwner)
         {
            case Owner.PLAYER:
               fillColor = 0x00FF00;
               break;
            case Owner.ALLY:
               fillColor = 0x0000FF;
               break;
            case Owner.NAP:
               fillColor = 0xFFFF00;
               break;
            case Owner.ENEMY:
               fillColor = 0xFF0000;
               break;
         }
         graphics.beginFill(fillColor);
         graphics.drawRect(0, 0, uw, uh);
         graphics.endFill();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _squadrons:ModelsCollection = new ModelsCollection();
      private var _squadronsSlave:ModelsCollectionSlave = new ModelsCollectionSlave(_squadrons, false);
      /**
       * Unmodifiable collection of <code>MSquadrons</code> that this component represents.
       */
      public function get squadrons() : IModelsList
      {
         return _squadronsSlave;
      }
      
      
      /**
       * Owner of all squadrons in this <code>CSquadronsMapIcon</code> component.
       */
      public function get squadronsOwner() : int
      {
         if (!hasSquadrons)
         {
            return Owner.UNDEFINED;
         }
         return MSquadron(_squadrons.getFirstItem()).owner;
      }
      
      
      /**
       * Indicates if this component has squadrons to represent.
       */
      public function get hasSquadrons() : Boolean
      {
         return !_squadrons.isEmpty;
      }
      
      
      public function get currentLocation() : LocationMinimal
      {
         return hasSquadrons ? MSquadron(_squadrons.getFirstItem()).currentHop.location : null;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Adds given squadron.
       * 
       * @param squadron a squadron to add
       * 
       * @throws ArgumentError if
       * <ul>
       *    <li><code>squadron</code> is <code>null</code></li>
       *    <li><code>squadron</code> has already been added</li>
       *    <li>if a squadron belongs to a different owners group than squadrons added before</li>
       * </ul>
       */
      public function addSquadron(squadron:MSquadron) : void
      {
         ClassUtil.checkIfParamNotNull("squadron", squadron);
         if (squadronsOwner != Owner.UNDEFINED && squadronsOwner != squadron.owner)
         {
            throwIllegalSquadronOwnerError(squadron);
         }
         if (_squadrons.contains(squadron))
         {
            throwSquadronAlreadyAddedError(squadron);
         }
         _squadrons.addItem(squadron);
         invalidateDisplayList();
      }
      
      
      /**
       * Removes given squadron.
       * 
       * @param squadron a squadron to remove
       * 
       * @throws ArgumentError if
       * <ul>
       *    <li><code>squadron</code> is <code>null</code></li>
       * </ul>
       */
      public function removeSquadron(squadron:MSquadron) : void
      {
         ClassUtil.checkIfParamNotNull("squadron", squadron);
         _squadrons.removeItem(squadron);
         invalidateDisplayList();
      }
      
      
      /**
       * Use this to find out if a given squadron model has been added to the list of squadrons
       * this component represents.
       *  
       * @param squadron squadron to look for
       * 
       * @return <code>true</code> if given squadron has been added to this <code>CSquadronsMapIcon</code>
       * component or <code>false</code> otherwise
       */
      public function hasSquadron(squadron:MSquadron) : Boolean
      {
         return _squadrons.contains(squadron);
      }
      
      
      public override function toString() : String
      {
         return "[class: " + ClassUtil.getClassName(this) + ", currentLocation: " + currentLocation +
                ", squadrons: " + squadrons + "]";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * @throws ArgumentError
       */
      private function throwIllegalSquadronOwnerError(squadron:MSquadron) : void
      {
         throw new ArgumentError(
            "Squadron " + squadron + " belongs to a different group of owners (" + squadron.owner +
            ") from squadrons already in the list (" + squadronsOwner + ")"
         );
      }
      
      
      /**
       * @throws ArgumentError
       */
      private function throwSquadronAlreadyAddedError(squadron:MSquadron) : void
      {
         throw new ArgumentError("Squadron " + squadron + " has already been added");
      }
   }
}