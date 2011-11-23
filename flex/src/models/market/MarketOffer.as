package models.market
{
   import components.market.events.MarketEvent;
   
   import models.BaseModel;
   import models.player.PlayerMinimal;
   
   import utils.MathUtil;
   import utils.locale.Localizer;
   
   public class MarketOffer extends BaseModel
   {
      public function MarketOffer()
      {
         super();
      }
      
      private var _player: PlayerMinimal;
      
      [Required]
      public function set player(value: PlayerMinimal): void
      {
         _player = value;
         dispatchPlayerChangeEvent();
      }
      
      [Bindable (event="offerOwnerChange")]
      public function get player(): PlayerMinimal
      {
         return _player;
      }
      
      [Bindable (event="offerOwnerChange")]
      public function get from(): String
      {
         return player == null?Localizer.string('Players', 'npc'):player.name;
      }
      
      [Bindable (event="offerOwnerChange")]
      public function get fromId(): int
      {
         return player == null?0:player.id;
      }
      
      [Bindable]
      public var selected: Boolean = false;
      
      [Required]
      [Bindable (event="fromAmountChange")]
      public function get fromAmount(): int
      {
         return _fromAmount;
      }
      
      public function set fromAmount(value: int): void
      {
         _fromAmount = value;
         dispatchFromAmountChangeEvent();
      }
      
      private var _fromAmount: int;
      
      [Required]
      [Bindable (event="willNotChange")]
      public function set fromKind(value: int): void
      {
         fromResource = OfferResourceKind.KINDS[value];
      }
      
      public function get fromKind(): int
      {
         if (fromResource == null)
         {
            return -1;
         }
         return int(OfferResourceKind[fromResource]);
      }
      
      [Bindable]
      public var fromResource: String;
      
      [Required]
      [Bindable (event="willNotChange")]
      public function set toKind(value: int): void
      {
         toResource = OfferResourceKind.KINDS[value];
      }
      
      public function get toKind(): int
      {
         if (toResource == null)
         {
            return -1;
         }
         return int(OfferResourceKind[toResource]);
      }
      
      [Bindable (event="fromAmountChange")]
      public function get toAmount(): int
      {
         return _fromAmount * rate;
      }
      
      [Bindable]
      public var toResource: String;
      
      private var rate: Number;
      
      [Required]
      public function set toRate(value: Number): void
      {
         rate = value;
         dispatchRateChangeEvent();
      }
      [Bindable (event="offerRateChange")]
      public function get toRate(): Number
      {
         return rate;
      }
      
      [Required]
      [Bindable]
      public var createdAt: Date;
      
      private function dispatchPlayerChangeEvent(): void
      {
         if (hasEventListener(MarketEvent.OFFER_OWNER_CHANGE))
         {
            dispatchEvent(new MarketEvent(MarketEvent.OFFER_OWNER_CHANGE));
         }
      }
      
      private function dispatchRateChangeEvent(): void
      {
         if (hasEventListener(MarketEvent.OFFER_RATE_CHANGE))
         {
            dispatchEvent(new MarketEvent(MarketEvent.OFFER_RATE_CHANGE));
         }
      }
      
      private function dispatchFromAmountChangeEvent(): void
      {
         if (hasEventListener(MarketEvent.FROM_AMOUNT_CHANGE))
         {
            dispatchEvent(new MarketEvent(MarketEvent.FROM_AMOUNT_CHANGE));
         }
      }
   }
}