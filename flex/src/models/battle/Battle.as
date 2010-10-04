package models.battle
{
   import com.developmentarc.core.utils.EventBroker;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.location.Location;
   import models.map.Map;
   import models.map.MapType;
   
   import mx.collections.ArrayCollection;
   
   import utils.ArrayUtil;
   import utils.random.Rndm;
   
   
   public class Battle extends Map
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
      
      
      [ArrayElementType("models.ModelsCollection")]
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
      
      
      /**
       * List of all flanks from all players.
       */
      public function get allFlanks() : ModelsCollection
      {
         var flanks:ModelsCollection = new ModelsCollection();
         for each (var alliance:BAlliance in alliances)
         {
            flanks.addAll(alliance.flanks);
         }
         return flanks;
      }
   }
}