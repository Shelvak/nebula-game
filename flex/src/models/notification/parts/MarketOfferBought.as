package models.notification.parts
{
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.player.PlayerMinimal;
   
   import mx.collections.ArrayCollection;
   
   import utils.Objects;
   import utils.locale.Localizer;
   
   
   public class MarketOfferBought extends BaseModel implements INotificationPart
   {
      /**
       * Constructor.
       * 
       * EVENT_MARKET_OFFER_BOUGHT = 11
       *
       * params = {
       * :buyer => Player#as_json(:mode => :minimal),
       * :planet => ClientLocation#as_json,
       * :from_kind => Fixnum (resource which buyer has bought),
       * :amount => Fixnum (amount which buyer has bought),
       * :to_kind => Fixnum (resource which buyer has paid with),
       * :cost => Fixnum (amount which buyer has paid),
       * :amount_left => Fixnum (amount left in the offer. Offer is depleted if
       * this is 0)
       * }
       */
      public function MarketOfferBought(notif:Notification = null)
      {
         super();
         if (notif != null)
         {
            var params: Object = notif.params;
            buyer = Objects.create(PlayerMinimal, params.buyer);
            location = Objects.create(Location, params.planet);
            fromKind = params.fromKind;
            toKind = params.toKind;
            amount = params.amount;
            cost = params.cost;
            amountLeft = params.amountLeft;
         }
      }
      
      public var fromKind: int;
      public var toKind: int;
      public var amount: int;
      public var cost: int;
      public var amountLeft: int;
      
      [Bindable (event="willNotChange")]
      public function get nothingsLeft(): Boolean
      {
         return amountLeft == 0;
      }
      
      public var buyer: PlayerMinimal;
      
      
      public function get title() : String
      {
         return Localizer.string("Notifications", "title.marketOfferBought");
      }
      
      
      public function get message() : String
      {
         return Localizer.string("Notifications", "message.marketOfferBought");
      }
      
      
      public var location:Location;
      public var buildings:ArrayCollection;
      
      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }
   }
}