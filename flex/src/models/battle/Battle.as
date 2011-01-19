package models.battle
{
   import com.developmentarc.core.utils.EventBroker;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.map.MMap;
   import models.map.MapType;
   
   import mx.collections.ArrayCollection;
   
   import utils.ArrayUtil;
   import utils.random.Rndm;
   
   
   public class Battle extends MMap
   {
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      public override function get mapType() : int
      {
         return MapType.BATTLE;
      }
      
      /**
       * A planet in which the battle takes place.
       */
      public var location:Location = null;
      
      public var rand: Rndm;
      
      public var logHash: Object;
      
      public var speed: Number;
      
      public var outcome: int = 0;
      
      public var ticksTotal: int = 0;
      
      public var groupOrders: int = 0;
      
      
      /**
       * Indicates if this is Free-For-All battle.
       */
      public function get isFFA() : Boolean
      {
         return alliances.length > 2;
      }
	  
	  public function get groundUnitCount(): int
	  {
		  var uCount: int = 0;
		  for each (var flank: BFlank in allFlanks)
		  {
			  uCount += flank.groundUnits.length;
		  }
		  return uCount;
	  }
     
     public function addAppearingUnit(unit: BUnit, flankIndex: int): void
     {
        getPlayerFlank(unit.playerId, flankIndex).addUnit(unit, BUnitKind.GROUND);
     }
     
     private function getPlayerFlank(playerId: int, flankIndex: int): BFlank
     {
        for each (var alliance: BAlliance in alliances)
        {
           if (alliance.hasPlayer(playerId))
           {
              return alliance.getFlankByIndex(flankIndex);
           }
        }
        return null;
     }
      
      public function getFlankByUnitId(unitId: int): BFlank
      {
         for each (var alliance: BAlliance in alliances)
         for each (var flank: BFlank in alliance.flanks)
         if (flank.getUnitById(unitId) != null)
            return flank;
         return null;
      }
      
      
      /**
       * Indicates if this is 1v1 battle (only two teams are participating in the battle).
       */
      public function get isDefenderVsOffender() : Boolean
      {
         return !isFFA;
      }
      
      
      /**
       * Idicates if any space units are participating in this battle.
       */
      protected function get hasSpaceUnits() : Boolean
      {
         for each (var flank:BFlank in allFlanks)
         {
            if (flank.hasSpaceUnits)
            {
               return true;
            }
         }
         return false;
      }
      
      
      /**
       * Idicates if any ground units are participating in this battle.
       */
      protected function get hasGroundUnits() : Boolean
      {
         if (buildings.length > 0)
         {
            return true;
         }
         for each (var flank:BFlank in allFlanks)
         {
            if (flank.hasGroundUnits)
            {
               return true;
            }
         }
         return false;
      }
      
      
      /**
       * <code>true</code> if only space units are participating in this battle.
       */
      public function get hasSpaceUnitsOnly() : Boolean
      {
         return !hasGroundUnits;
      }
      
      /**
       * <code>true</code> if only ground units are participating in this battle.
       */
      public function get hasGroundUnitsOnly() : Boolean
      {
         return !hasSpaceUnits;
      }
      
      
      /**
       * <code>true</code> if both both - ground and space - unit types are participating
       * in this battle.
       */
      public function hasBothUnitTypes() : Boolean
      {
         return hasSpaceUnits && hasGroundUnits;
      }
      
      
      /* ################### */
      /* ### COLLECTIONS ### */
      /* ################### */
      
      
      /**
       * All aliances participating in the battle. Here "aliances" is a <code>ModelsCollection</code>
       * containing instance of <code>BAliance</code>.
       */
      public var alliances:ArrayCollection = new ArrayCollection();
      
      /**
       * All defender buildings participating in the battle 
       */      
      public var buildings:ModelsCollection = new ModelsCollection();
      
      /**
       * All battle ticks 
       */      
      public var log:ArrayCollection = null;
      
      
      /**
       * 
       * @param id
       * @return BUnit if found in aliances flanks, null if not
       * 
       */
      private function getUnitById(id: int): BaseModel
      {
         for each(var alliance: BAlliance in alliances)
         {
            var unit:* = alliance.getUnitById(id);
            if (unit != null)
            {
               return unit;
            }
         }
         return null;
      }
      
      public override function definesLocation(location:LocationMinimal):Boolean
      {
         return false;
      }
      
      /**
       * List of all flanks from all players.
       */
      public function get allFlanks() : ModelsCollection
      {
         var source:Array = new Array();
         for each (var alliance:BAlliance in alliances)
         {
            for each (var flank:BFlank in alliance.flanks)
            {
               source.push(flank);
            }
         }
         return new ModelsCollection(source);
      }
   }
}