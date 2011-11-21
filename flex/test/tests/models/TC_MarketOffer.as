package tests.models
{

   import models.market.MarketOffer;

   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;

   import utils.Objects;

   public class TC_MarketOffer
   {
      
      [Before]
      public function setUp() : void
      {
      }
      
      [Test]
      public function testDefaultKindValues() : void
      {
         var mOffer: MarketOffer = new MarketOffer();
         assertThat(mOffer.fromKind, equalTo(-1));
         assertThat(mOffer.toKind, equalTo(-1));
      }
   }
}