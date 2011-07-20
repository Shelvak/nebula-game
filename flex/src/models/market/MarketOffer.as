package models.market
{
   import components.market.events.MarketEvent;
   
   import models.BaseModel;
   import models.player.PlayerMinimal;
   
   import utils.MathUtil;
   
   public class MarketOffer extends BaseModel
   {
      public function MarketOffer(_from: String, _to: String)
      {
         player = new PlayerMinimal();
         player.id = Math.round(Math.random() * 100 + 3);
         player.name = 'Žaidėjas'+player.id;
         fromAmount = Math.round(Math.random() * 1000);
         toAmount = Math.round(Math.random() * 1000);
         fromKind = _from;
         toKind = _to;
         createdAt = new Date();
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
         return player.name;
      }
      
      [Bindable (event="offerOwnerChange")]
      public function get fromId(): int
      {
         return player.id;
      }
      
      [Bindable]
      public var selected: Boolean = false;
      
      [Required]
      [Bindable]
      public var fromAmount: int;
      
      [Bindable]
      public var toAmount: int;
      
      [Required]
      [Bindable]
      public var fromKind: String;
      
      [Required]
      [Bindable]
      public var toKind: String;
      
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
   }
}