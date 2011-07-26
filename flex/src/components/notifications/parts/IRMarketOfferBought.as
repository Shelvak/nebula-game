package components.notifications.parts
{
   import components.base.ImageAndLabel;
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.MarketOfferBoughtSkin;
   
   import controllers.ui.NavigationController;
   
   import flash.events.MouseEvent;
   
   import models.market.OfferResourceKind;
   import models.notification.parts.MarketOfferBought;
   
   import spark.components.Button;
   import spark.components.Label;
   
   import utils.locale.Localizer;
   
   
   public class IRMarketOfferBought extends IRNotificationPartBase
   {
      public function IRMarketOfferBought()
      {
         super();
         setStyle("skinClass", MarketOfferBoughtSkin);
      };
      
      
      [SkinPart(required="true")]
      public var location:MiniLocationComp;
      
      
      [SkinPart(required="true")]
      public var message1:Label;
      [SkinPart(required="true")]
      public var message2:Label;
      [SkinPart(required="true")]
      public var lblFor:Label;
      [SkinPart(required="true")]
      public var lblResourcesLeft:Label;
      
      
      [SkinPart(required="true")]
      public var fromResource:ImageAndLabel;
      [SkinPart(required="true")]
      public var toResource:ImageAndLabel;
      
      [SkinPart(required="true")]
      public var lblInvolvedPlayer:Button;
      
      private function getText(prop: String, params: Array = null): String
      {
         return Localizer.string('Notifications', 'label.marketOfferBought.'+
            prop, params);
      }
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            var part:MarketOfferBought = MarketOfferBought(notificationPart);
            location.location = part.location;
            message1.text = getText('message1');
            message2.text = getText('message2');
            lblInvolvedPlayer.label = part.buyer.name;
            lblInvolvedPlayer.addEventListener(MouseEvent.CLICK, 
               function(e: MouseEvent): void
               {
                  NavigationController.getInstance().showPlayer(part.buyer.id);
               }
            );
            lblFor.text = getText('for');
            lblResourcesLeft.text = (part.amountLeft > 0
               ? getText('amountLeft',
            [part.amountLeft, OfferResourceKind.KINDS[part.fromKind]])
               : getText('allBought'));
            fromResource.type = OfferResourceKind.KINDS[part.fromKind];
            toResource.type = OfferResourceKind.KINDS[part.toKind];
            fromResource.textToDisplay = part.amount.toString();
            toResource.textToDisplay = part.cost.toString();
         }
         f_NotificationPartChange = false;
      }
   }
}