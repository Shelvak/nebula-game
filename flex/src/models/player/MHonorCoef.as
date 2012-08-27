package models.player
{
   import controllers.players.PlayersCommand;

   import flash.events.EventDispatcher;

   import models.movement.events.MSquadronEvent;
   import models.player.events.MHonorCoefEvent;

   import utils.Events;
   import utils.Objects;
   import utils.locale.Localizer;


   /**
    * Wrapper of the <code>MSquadKillReward</code> singleton. This class implements all common
    * logic regarding the retrieval of honor coefficient.
    */
   public class MHonorCoef extends EventDispatcher
   {
      private function get killReward(): MSquadKillReward {
         return MSquadKillReward.getInstance()
      }

      private var _playerId: int;

      /**
       * @param label_yetUnknown A label which is show when honor coefficient has not yet been
       * retrieved from the server. Default is <code>Movement.label.honorCoef</code>.
       *
       * @param label_notInEffect A label which is shown when honor coefficient is not
       * applied in a given context. Default is <code>Movement.label.noHonorCoef</code>.
       */
      public function MHonorCoef(
         playerId: int,
         precision: int = 2,
         label_yetUnknown: String = null,
         label_notInEffect: String = null)
      {
         _playerId = Objects.paramIsId("playerId", playerId);
         _precision = Objects.paramPositiveNumber("precision", precision);
         _label = label_yetUnknown == null
            ? getString("label.honorCoef")
            : Objects.paramNotEmpty("label_yetUnknown", label_yetUnknown);
         _label_notInEffect = label_notInEffect == null
            ? getString("label.noHonorCoef")
            : Objects.paramNotEmpty("label_notInEffect", label_notInEffect);
      }

      private var _precision: int;
      private var _value: Number = NaN;
      private var _label: String;
      [Bindable(event=MHonorCoefEvent.CHANGE)]
      public function get labelOrValue(): String {
         return isNaN(_value) ? _label : (_value * 100).toFixed(_precision) + "%";
      }

      private var _label_notInEffect: String;
      public function get label_notInEffect(): String {
         return _label_notInEffect;
      }

      public function get tooltip(): String {
         return getString("tooltip.honorCoef");
      }

      public function retrieveHonorCoef(): void {
         killReward.addEventListener(
            MSquadronEvent.MULTIPLIER_CHANGE,
            killReward_multiplierChangeHandler, false, 0, true);
         new PlayersCommand(
            PlayersCommand.BATTLE_VPS_MULTIPLIER,
            {"targetId": _playerId}
         ).dispatch();
      }

      private function killReward_multiplierChangeHandler(event: MSquadronEvent): void {
         killReward.removeEventListener(
            MSquadronEvent.MULTIPLIER_CHANGE, killReward_multiplierChangeHandler, false);
         _value = killReward.multiplier;
         Events.dispatchSimpleEvent(this, MHonorCoefEvent, MHonorCoefEvent.CHANGE);
      }

      private function getString(property: String): String {
         return Localizer.string("Movement", property);
      }
   }
}
