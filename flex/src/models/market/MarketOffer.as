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
         what = Math.round(Math.random() * 1000);
         forWhat = Math.round(Math.random() * 1000);
         whatResource = _from;
         toResource = _to;
         createdAt = new Date();
         super();
      }
      
      private var _player: PlayerMinimal;
      
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
      
      [Bindable]
      public var what: int;
      
      [Bindable]
      public var forWhat: int;
      
      [Bindable]
      public var whatResource: String;
      
      [Bindable]
      public var toResource: String;
      
      public function get rate(): Number
      {
         return MathUtil.round(Number(forWhat)/what, 2);
      }
      [Bindable]
      public var createdAt: Date;
      
      private function dispatchPlayerChangeEvent(): void
      {
         if (hasEventListener(MarketEvent.OFFER_OWNER_CHANGE))
         {
            dispatchEvent(new MarketEvent(MarketEvent.OFFER_OWNER_CHANGE));
         }
      }
   }
}