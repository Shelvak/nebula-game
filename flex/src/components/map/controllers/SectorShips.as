/**
 * Created by IntelliJ IDEA.
 * User: MikisM
 * Date: 11.12.6
 * Time: 11.42
 * To change this template use File | Settings | File Templates.
 */
package components.map.controllers
{
   import interfaces.IEqualsComparable;

   import utils.Objects;


   public class SectorShips implements IEqualsComparable
   {
      public function SectorShips(player:Boolean = false,
                                  alliance:Boolean = false,
                                  nap:Boolean = false,
                                  enemy:Boolean = false,
                                  npc:Boolean = false) {
         this._player = player;
         this._alliance = alliance;
         this._nap = nap;
         this._enemy = enemy;
         this._npc = npc;
      }
      
      private var _player: Boolean;
      public function get player(): Boolean {
         return _player;
      }

      private var _alliance: Boolean;
      public function get alliance(): Boolean {
         return _alliance;
      }

      private var _nap: Boolean;
      public function get nap(): Boolean {
         return _nap;
      }

      private var _enemy: Boolean;
      public function get enemy(): Boolean {
         return _enemy;
      }

      private var _npc: Boolean;
      public function get npc(): Boolean {
         return _npc;
      }

      public function get shipsPresent(): Boolean {
         return _alliance || _enemy || _nap || _npc || _player;
      }

      public function toString(): String {
         return "[class: " + Objects.getClassName(this)
                   + ", player: " + _player
                   + ", alliance: " + _alliance
                   + ", nap: " + _nap
                   + ", enemy: " + _enemy
                   + ", npc: " + _npc + "]";
      }

      public function equals(o: Object): Boolean {
         if (!(o is SectorShips)) {
            return false;
         }
         if (o === this) {
            return true;
         }
         var sectorShips:SectorShips = SectorShips(o);
         return this._alliance == sectorShips._alliance
                   && this._enemy == sectorShips._enemy
                   && this._nap == sectorShips._nap
                   && this._npc == sectorShips._npc
                   && this._player == sectorShips._player;
      }
   }
}
