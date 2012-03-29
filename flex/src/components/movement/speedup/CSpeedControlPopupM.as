package components.movement.speedup
{
   import components.movement.speedup.events.SpeedControlEvent;

   import config.Config;

   import controllers.units.OrdersController;

   import flash.events.EventDispatcher;

   import interfaces.ICleanable;
   import interfaces.IUpdatable;

   import models.ModelLocator;
   import models.player.Player;
   import models.player.events.PlayerEvent;

   import namespaces.client_internal;

   import utils.DateUtil;
   import utils.Events;
   import utils.Objects;
   import utils.UrlNavigate;
   import utils.locale.Localizer;


   [Event(
      name="speedModifierChange",
      type="components.movement.speedup.events.SpeedControlEvent")]

   [Event(
      name="playerCredsChange",
      type="components.movement.speedup.events.SpeedControlEvent")]

   [Event(
      name="modeChange",
      type="components.movement.speedup.events.SpeedControlEvent")]
   
   
   public class CSpeedControlPopupM extends EventDispatcher implements IUpdatable, ICleanable
   {
      public static const MODE_MODIFIER_BASED: int = 0;
      public static const MODE_TIME_BASED: int = 1;

      private static function get URL_NAV(): UrlNavigate {
         return UrlNavigate.getInstance();
      }

      private static function get ORDERS_CTRL(): OrdersController {
         return OrdersController.getInstance();
      }

      private static function get PLAYER(): Player {
         return ModelLocator.getInstance().player;
      }


      private var _baseTripValues: BaseTripValues;

      private var _modifierBasedControl: ModifierBasedSpeedControl;
      internal function get modifierBasedControl(): ModifierBasedSpeedControl {
         return _modifierBasedControl;
      }

      private var _timeBasedControl: TimeBasedSpeedControl;
      internal function get timeBasedControl(): TimeBasedSpeedControl {
         return _timeBasedControl;
      }
      
      public function CSpeedControlPopupM(baseTripTime: Number, hopCount: int) {
         _baseTripValues = new BaseTripValues(
            Objects.paramPositiveNumber("baseTripTime", baseTripTime, false),
            Objects.paramPositiveNumber("hopCount", hopCount, false)
         );
         _modifierBasedControl = new ModifierBasedSpeedControl(
            _baseTripValues, new SpeedupValues(_baseTripValues)
         );
         _timeBasedControl = new TimeBasedSpeedControl(
            _baseTripValues, new SpeedupValues(_baseTripValues)
         );
         addControlInstanceEventHandlers();
         PLAYER.addEventListener(
            PlayerEvent.CREDS_CHANGE, player_credsChangeHandler, false, 0, true
         );
      }

      public function cleanup(): void {
         if (PLAYER != null) {
            PLAYER.removeEventListener(
               PlayerEvent.CREDS_CHANGE, player_credsChangeHandler, false
            );
         }
         onCancel = null;
         onConfirm = null;
      }

      private var _mode: int = MODE_MODIFIER_BASED;
      public function get mode(): int {
         return _mode;
      }

      private function setMode(value: int): void {
         if (_mode != value) {
            removeControlInstanceEventHandlers();
            const currentModifierValue: Number = this.speedModifier;
            _mode = value;
            controlInstance.speedModifier = currentModifierValue;
            addControlInstanceEventHandlers();
            dispatchSpeedControlEvent(SpeedControlEvent.MODE_CHANGE);
         }
      }

      public function setModifierBasedMode(): void {
         setMode(MODE_MODIFIER_BASED);
      }

      public function setTimeBasedMode(): void {
         setMode(MODE_TIME_BASED);
      }

      [Bindable(event="modeChange")]
      public function get modifierBasedControlsActive(): Boolean {
         return mode == MODE_MODIFIER_BASED;
      }

      [Bindable(event="modeChange")]
      public function get timeBasedControlsActive(): Boolean {
         return !modifierBasedControlsActive;
      }

      private function get controlInstance(): ISpeedControl {
         return modifierBasedControlsActive
                   ? _modifierBasedControl
                   : _timeBasedControl;
      }

      private function addControlInstanceEventHandlers(): void {
         controlInstance.addEventListener(
            SpeedControlEvent.SPEED_MODIFIER_CHANGE,
            controlInstance_speedModifierChangeHandler
         );
      }

      private function removeControlInstanceEventHandlers(): void {
         controlInstance.removeEventListener(
            SpeedControlEvent.SPEED_MODIFIER_CHANGE,
            controlInstance_speedModifierChangeHandler
         );
      }

      private function controlInstance_speedModifierChangeHandler(event: SpeedControlEvent): void {
         dispatchSpeedControlEvent(SpeedControlEvent.SPEED_MODIFIER_CHANGE);
         dispatchPlayerCredsChangeEvent();
      }

      public function get arrivesIn(): Number {
         return controlInstance.arrivalEvent.occursIn;
      }

      /**
       * This is for tests only. Do not use in normal code. Sets
       * speedModifier on controlInstance.
       */
      client_internal function setSpeedModifier(value: Number): void {
         controlInstance.speedModifier = value;
      }
      public function get speedModifier(): Number {
         return controlInstance.speedModifier;
      }
      
      
      /* ############ */
      /* ### COST ### */
      /* ############ */

      private function player_credsChangeHandler(event: PlayerEvent): void {
         dispatchPlayerCredsChangeEvent();
      }

      [Bindable(event="speedModifierChange")]
      public function get speedUpCost(): int {
         return controlInstance.speedupCost;
      }

      [Bindable(event="speedModifierChange")]
      public function get showSpeedUpCost(): Boolean {
         return speedModifier < 1.0;
      }

      [Bindable(event="playerCredsChange")]
      public function get playerHasEnoughCreds(): Boolean {
         return PLAYER.creds >= speedUpCost;
      }

      
      /* ############### */
      /* ### ACTIONS ### */
      /* ############### */

      /**
       * Additional callback to invoke when <code>confirm()</code> is called.
       */
      public var onConfirm: Function = null;

      /**
       * Additional callback to invoke when <code>cancel()</code> is called.
       */
      public var onCancel: Function = null;
      
      /**
       * Confirms speedup of squad.
       */
      public function confirm(): void {
         invokeIfNotNull(onConfirm);
         ORDERS_CTRL.commitOrder(speedModifier);
      }

      /**
       * Cancels speedup step.
       */
      public function cancel(): void {
         invokeIfNotNull(onCancel);
         ORDERS_CTRL.cancelTargetLocation();
      }

      /**
       * Resets speed modifier to default value.
       */
      public function reset(): void {
         _modifierBasedControl.reset();
         _timeBasedControl.reset();
      }

      public function buyCreds(): void {
         URL_NAV.showBuyCreds();
      }

      public function openPreBattleCooldownInfo(): void {
         URL_NAV.showInfo("after-jump-cooldown");
      }


      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public function update(): void {
         controlInstance.update();
      }

      public function resetChangeFlags(): void {
         controlInstance.resetChangeFlags();
      }
      
      
      /* ##################### */
      /* ### STATIC LABELS ### */
      /* ##################### */

      public function get label_confirmButton(): String {
         return getString("label.confirm");
      }

      public function get label_buyCredsButton(): String {
         return getString("label.buyCreds");
      }

      public function get label_resetButton(): String {
         return getString("label.reset");
      }

      public function get label_cancelButton(): String {
         return getString("label.cancel");
      }

      public function get label_cooldownInfoButton(): String {
         return getString("label.learnMore");
      }

      public function get label_cooldownInfo(): String {
         return getString(
            "speedup.message.combatCooldownInfo",
            [DateUtil.secondsToHumanString(Config.getPreBattleCooldownDuration())]
         );
      }

      public function get label_changeSpeed(): String {
         return getString("speedup.label.changeSpeed");
      }
      
      
      /* ###################### */
      /* ### DYNAMIC LABELS ### */
      /* ###################### */

      [Bindable(event="speedModifierChange")]
      public function get label_arrivesIn(): String {
         return getString("speedup.label.arrivesIn", [
            controlInstance.arrivalEvent.occursInString()
         ]);
      }

      [Bindable(event="speedModifierChange")]
      public function get label_speedupCost(): String {
         return getString("speedup.message.cost", [speedUpCost]);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function dispatchPlayerCredsChangeEvent(): void {
         dispatchSpeedControlEvent(SpeedControlEvent.PLAYER_CREDS_CHANGE);
      }

      private function dispatchSpeedControlEvent(type: String): void {
         Events.dispatchSimpleEvent(this, SpeedControlEvent, type);
      }

      private static function getString(property: String,
                                        parameters: Array = null): String {
         return Localizer.string("Movement", property, parameters);
      }

      private static function invokeIfNotNull(fun: Function): void {
         if (fun != null) {
            fun.call();
         }
      }
   }
}
