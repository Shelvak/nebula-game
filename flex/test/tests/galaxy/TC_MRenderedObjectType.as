package tests.galaxy
{
   import components.map.space.galaxy.entiregalaxy.MiniSSType;
   
   import ext.hamcrest.object.definesProperty;
   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.metadata.withMetadataTag;
   
   import models.galaxy.MRenderedFowLine;
   import models.galaxy.MRenderedObjectType;
   import models.galaxy.MRenderedSS;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   public final class TC_MRenderedObjectType
   {
      [Test]
      public function rendered(): void {
         const galaxyMock: MEntireGalaxyMock = new MEntireGalaxyMock();
         
         const object: MRenderedObjectType = new MRenderedObjectType(galaxyMock);
         assertThat( "should be rendered by default", object.rendered, isTrue() );
         
         object.rendered = false;
         assertThat( "should not be rendered anymore", object.rendered, isFalse() );
         assertThat(
            "changing rendered should call IMEntireGalaxy.render()",
            galaxyMock.renderCalled, isTrue());
      }
      
      [Test]
      public function metadata(): void {
         assertThat(
            MRenderedObjectType,
            definesProperty ("rendered", withMetadataTag ("Bindable")));
      }
      
      [Test]
      public function equals_MRenderedSS(): void {
         function $ss(type: String): MRenderedSS {
            return new MRenderedSS(new MEntireGalaxyMock(), type);
         }
         
         const ss: MRenderedSS = $ss(MiniSSType.ALLIANCE_HOME);
         assertThat( "compared with another object type", ss, not (equals (new Object())) );
         assertThat( "compared with another mini ss type", ss, not (equals ($ss(MiniSSType.PULSAR))) );
         assertThat( "compared with same ss type", ss, equals ($ss(MiniSSType.ALLIANCE_HOME) ) );
      }
      
      [Test]
      public function equals_MRenderedFowLine(): void {
         function $line(): MRenderedFowLine {
            return new MRenderedFowLine(new MEntireGalaxyMock())
         }
         
         assertThat( "compared with another object type", $line(), not (equals (new Object())) );
         assertThat( "compared with another line", $line(), equals ($line()) );
      }
      
      [Test]
      public function toString_MRenderedSS(): void {
         assertThat(
            new MRenderedSS(new MEntireGalaxyMock(), MiniSSType.PLAYER_HOME).toString(),
            equals ('[class: models.galaxy::MRenderedSS, type: "yourHome"]'));
      }
      
      [Test]
      public function toString_MRenderedFowLine(): void {
         assertThat(
            new MRenderedFowLine(new MEntireGalaxyMock()).toString(),
            equals("[class: models.galaxy::MRenderedFowLine]"));
      }
   }
}


import models.galaxy.IMEntireGalaxy;
import models.galaxy.MRenderedObjectType;


final class MEntireGalaxyMock implements IMEntireGalaxy
{
   private var _renderCalled: Boolean = false;
   
   public function rerender(): void {
      _renderCalled = true;
   }

   public function doRerender(): void {
   }
   
   public function get renderCalled(): Boolean {
      return _renderCalled;
   }
}