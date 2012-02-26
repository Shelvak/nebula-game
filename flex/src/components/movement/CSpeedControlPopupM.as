package components.movement
{
   import components.movement.events.CSpeedControlPopupMEvent;
   
   import config.Config;
   
   import controllers.units.OrdersController;
   
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   
   import interfaces.ICleanable;
   import interfaces.IUpdatable;
   
   import models.ModelLocator;
   import models.parts.UnitUpgradable;
   import models.player.events.PlayerEvent;
   import models.time.MTimeEventFixedInterval;
   import models.unit.Unit;
   
   import utils.DateUtil;
   import utils.Events;
   import utils.Objects;
   import utils.UrlNavigate;
   import utils.locale.Localizer;
   
   
   /**
    * @see components.movement.events.CSpeedControlPopupMEvent#SPEED_MODIFIER_CHANGE
    */
   [Event(name="speedModifierChange", type="components.movement.events.CSpeedControlPopupMEvent")]
   
   
   /**
    * @see components.movement.events.CSpeedControlPopupMEvent#PLAYER_CREDS_CHANGE
    */
   [Event(name="playerCredsChange", type="components.movement.events.CSpeedControlPopupMEvent")]
   
   
   public class CSpeedControlPopupM extends EventDispatcher implements IUpdatable, ICleanable
   {
      private function get ORDERS_CTRL(): OrdersController {
         return OrdersController.getInstance();
      }

      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      /**
       * Contructs <code>CSpeedControlPopupM</code> with properties set to their initial values.
       * 
       * @param baseTripTime time (number of seconds) needed for squad to reach its destination without
       *                     modifier applied. <b>Must be positive non-zero number.</b>
       * @param hopCount int total hops to complete the trip 
       *                 <b>Must be positive non-zero integer.</b>
       */
      public function CSpeedControlPopupM(baseTripTime: Number, hopCount: int) {
         Objects.paramPositiveNumber("baseTripTime", baseTripTime, false);
         Objects.paramPositiveNumber("hopCount", hopCount, false);
         _baseTripTime = baseTripTime;
         _arrivalDate = new MTimeEventFixedInterval();
         _arrivalDate.occuresIn = _baseTripTime;
         _hopCount = hopCount;
         ML.player.addEventListener(
            PlayerEvent.CREDS_CHANGE, player_credsChangeHandler, false, 0, true
         );
      }

      public function cleanup(): void {
         if (ML.player != null) {
            ML.player.removeEventListener(
               PlayerEvent.CREDS_CHANGE, player_credsChangeHandler, false
            );
         }
         onCancel = null;
         onConfirm = null;
      }
      
      private var _hopCount: int;

      /**
       * for test cases
       */
      public function get hopCount(): int {
         return _hopCount;
      }


      /* ############ */
      /* ### TIME ### */
      /* ############ */
      
      private var _baseTripTime:Number;
      /**
       * Time needed for a squad to reach its destination. The value for this property must be passed
       * to the constructor.
       */
      public function get baseTripTime(): Number {
         return _baseTripTime;
      }

      private var _arrivalDate: MTimeEventFixedInterval;
      [Bindable(event="willNotChange")]
      /**
       * Squad arrival to its destination date. The object returns values with speed modifier applied.
       * The object is updated when <code>speedModifier</code> changes
       * (<code>CSpeedControlPopupM.SPEED_MODIFIER_CHANGE</code> event is dispatched).
       * 
       * <p>Never null.</p>
       */
      public function get arrivalDate(): MTimeEventFixedInterval {
         return _arrivalDate;
      }
      
      
      /* ############ */
      /* ### COST ### */
      /* ############ */
      
      [Bindable(event="speedModifierChange")]
      /**
       * Amount of credits the speed up of a squad will cost. Property changes when <code>speedModifier</code>
       * changes.
       * 
       * <p>
       * [Bindable(event="speedModifierChange")]
       * </p>
       */
      public function get speedUpCost(): int {
         return speedModifier < 1 ? Unit.getMovementSpeedUpCredsCost(
            1.0 - speedModifier, _hopCount) : 0;
      }

      [Bindable(event="speedModifierChange")]
      /**
       * Should the speed up cost be shown to the player. Property changes when <code>speedModifier</code>
       * changes.
       *
       * <p>
       * [Bindable(event="speedModifierChange")]
       * </p>
       */
      public function get showSpeedUpCost(): Boolean {
         return _speedModifier < 1.0;
      }

      [Bindable(event="playerCredsChange")]
      /**
       * Indicates if player has enough creds to speed up squad movement. This property changes when
       * <code>speedModifier</code> or <code>ModelLocator.player.creds</code> changes.
       *
       * <p>
       * [Bindable(event="playerCredsChange")]
       * </p>
       */
      public function get playerHasEnoughCreds(): Boolean {
         return ML.player.creds >= speedUpCost;
      }

      private function player_credsChangeHandler(event: PlayerEvent): void {
         dispatchPlayerCredsChangeEvent();
      }

      private function dispatchPlayerCredsChangeEvent(): void {
         Events.dispatchSimpleEvent(
            this, CSpeedControlPopupMEvent,
            CSpeedControlPopupMEvent.PLAYER_CREDS_CHANGE
         );
      }
      
      
      /* ###################### */
      /* ### SPEED MODIFIER ### */
      /* ###################### */

      private var _speedModifier: Number = 1.0;
      [Bindable(event="speedModifierChange")]
      /**
       * Squad speed modifier. The lesser this value is, the faster squadron will reach its destination.
       * Setting this property to value greater than <code>speedModifierMax</code> will actually set it
       * to <code>speedModifierMax</code> (same goes for <code>speedModifierMin</code>).
       * 
       * <p>
       * [Bindable(event="speedModifierChange")]
       * </p>
       */
      public function set speedModifier(value: Number): void {
         if (_speedModifier != value) {
            if (value < speedModifierMin) {
               value = speedModifierMin;
            }
            else if (value > speedModifierMax) {
               value = speedModifierMax;
            }
            _speedModifier = value;
            _arrivalDate.occuresIn = Math.floor(_baseTripTime * value);
            Events.dispatchSimpleEvent(
               this, CSpeedControlPopupMEvent,
               CSpeedControlPopupMEvent.SPEED_MODIFIER_CHANGE
            );
            dispatchPlayerCredsChangeEvent();
         }
      }
      /**
       * @private
       */
      public function get speedModifier(): Number {
         return _speedModifier;
      }

      [Bindable(event="willNotChange")]
      /**
       * @see config.Config#getMinMovementSpeedModifier()
       */
      public function get speedModifierMin(): Number {
         return Config.getMinMovementSpeedModifier();
      }

      [Bindable(event="willNotChange")]
      /**
       * @see config.Config#getMaxMovementSpeedModifier()
       */
      public function get speedModifierMax(): Number {
         return Config.getMaxMovementSpeedModifier();
      }
      
      
      /* ############### */
      /* ### ACTIONS ### */
      /* ############### */
      
      /**
       * Additional callback to invoke when <code>confirm()</code> is called.
       * 
       * @default null
       */
      public var onConfirm:Function = null;
      
      /**
       * Additional callback to invoke when <code>cancel()</code> is called.
       */
      public var onCancel:Function = null;
      
      /**
       * Confirms speedup of squad: calls <code>OrdersController.commitOrder()</code>.
       */
      public function confirm(): void {
         invokeIfNotNull(onConfirm);
         ORDERS_CTRL.commitOrder(speedModifier);
      }
      
      /**
       * Navigates to a page where player can buy credits.
       */
      public function buyCreds(): void {
         UrlNavigate.getInstance().showBuyCreds();
      }

      /**
       * Resets speed modifier to default value.
       */
      public function reset(): void {
         speedModifier = 1.0;
      }

      /**
       * Cancels speed up step and allows user to select another destination: calls
       * <code>OrdersController.cancelLocation()</code>.
       */
      public function cancel(): void {
         invokeIfNotNull(onCancel);
         ORDERS_CTRL.cancelTargetLocation();
      }

      /**
       * Opens up a wiki page with pre-battle cooldown information.
       */
      public function openPreBattleCooldownInfo(): void {
         UrlNavigate.getInstance().showInfo('after-jump-cooldown');
      }


      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */

      public function update(): void {
         _arrivalDate.update();
      }

      public function resetChangeFlags(): void {
         _arrivalDate.resetChangeFlags();
      }
      
      
      /* ##################### */
      /* ### STATIC LABELS ### */
      /* ##################### */

      [Bindable(event="willNotChange")]
      public function get label_confirmButton(): String {
         return getString("label.confirm");
      }

      [Bindable(event="willNotChange")]
      public function get label_buyCredsButton(): String {
         return getString("label.buyCreds");
      }

      [Bindable(event="willNotChange")]
      public function get label_resetButton(): String {
         return getString("label.reset");
      }

      [Bindable(event="willNotChange")]
      public function get label_cancelButton(): String {
         return getString("label.cancel");
      }

      [Bindable(event="willNotChange")]
      public function get label_cooldownInfoButton(): String {
         return getString("label.learnMore");
      }

      [Bindable(event="willNotChange")]
      public function get text_cooldownInfoLabel(): String {
         return getString(
            "message.combatCooldownInfo",
            [DateUtil.secondsToHumanString(Config.getPreBattleCooldownDuration())]
         );
      }

      [Bindable(event="willNotChange")]
      public function get label_changeSpeed(): String {
         return getString("label.changeSpeed");
      }
      
      
      /* ###################### */
      /* ### DYNAMIC LABELS ### */
      /* ###################### */

      public function text_arrivesAtLabel(occuresAt: Date): String {
         return getString("label.arrivesAt",
                          [DateUtil.formatShortDateTime(occuresAt)]);
      }

      [Bindable(event="speedModifierChange")]
      public function get text_arrivesInLabel(): String {
         return getString("label.flightTime", [
            DateUtil.secondsToHumanString(_arrivalDate.occuresIn)
         ]);
      }

      [Bindable(event="speedModifierChange")]
      public function get text_speedUpCostLabel(): String {
         return getString("message.speedUpCost", [speedUpCost]);
      }
      
      
      /* ############## */
      /* ### Object ### */
      /* ############## */

      public override function toString(): String {
         return "[class: " + Objects.getClassName(this) +
                   ", baseTripTime: " + _baseTripTime +
                   ", speedMod: " + _speedModifier +
                   ", speedModMin: " + speedModifierMin +
                   ", speedModMax: " + speedModifierMax +
                   ", arrivalDate: " + _arrivalDate + "]";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function getString(property: String,
                                 parameters: Array = null): String {
         return Localizer.string("Movement", property, parameters);
      }

      private function invokeIfNotNull(fun: Function): void {
         if (fun != null) {
            fun.call();
         }
      }
   }
}
