package tests.galaxy
{
   import components.map.space.galaxy.entiregalaxy.MiniSS;
   import components.map.space.galaxy.entiregalaxy.MiniSSType;

   import ext.hamcrest.collection.array;
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;

   import models.galaxy.MEntireGalaxy;
   import models.galaxy.MRenderedFowLine;
   import models.galaxy.MRenderedSS;
   import models.galaxy.events.MEntireGalaxyEvent;
   import models.map.MapArea;

   import namespaces.client_internal;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.not;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;


   public final class TC_MEntireGalaxy
   {
      private var galaxy: MEntireGalaxy

      [Before]
      public function setUp(): void {
         galaxy = new MEntireGalaxy(
            new Vector.<MapArea>(), [], new MiniSS([0, 0], MiniSSType.PLAYER_HOME));
      }

      [Test]
      public function initialization(): void {
         function $ss(type: String): MRenderedSS {
            return new MRenderedSS(galaxy, type);
         }

         assertThat(
            "should have created one instance of MRenderedObjectType for each rendered object type",
            galaxy.renderedObjectTypes, array(
               equals (new MRenderedFowLine(galaxy)),
               equals ($ss(MiniSSType.PLAYER_HOME)),
               equals ($ss(MiniSSType.ALLIANCE_HOME)),
               equals ($ss(MiniSSType.NAP_HOME)),
               equals ($ss(MiniSSType.ENEMY_HOME)),
               equals ($ss(MiniSSType.REGULAR)),
               equals ($ss(MiniSSType.PULSAR)),
               equals ($ss(MiniSSType.WORMHOLE))
            ));
      }
      
      [Test]
      public function rerender(): void {
         assertThat("by default galaxy should not be marked as needing rerendering",
            galaxy.client_internal::needsRerender, isFalse());
         
         assertThat(
            "invoking doRerender() when galaxy is not marked for rerendering", galaxy.doRerender,
            not (causes (galaxy) .toDispatchEvent (MEntireGalaxyEvent.RERENDER)));
         
         galaxy.rerender();
         assertThat(
            "should be marked as needing rerendering",
            galaxy.client_internal::needsRerender, isTrue());
         assertThat(
            "invoking doRerender() when galaxy is marked for rerendering", galaxy.doRerender,
            causes (galaxy) .toDispatchEvent (MEntireGalaxyEvent.RERENDER));
         assertThat(
            "after doRerender() galaxy should not be marked as needing rerendering",
            galaxy.client_internal::needsRerender, isFalse());
      }

      [Test]
      public function solarSystems(): void {
         function $ss(type: String): MiniSS {
            return new MiniSS([0, 0], type);
         }

         const playerHome: MiniSS = $ss(MiniSSType.PLAYER_HOME);
         const allyHome: MiniSS = $ss(MiniSSType.ALLIANCE_HOME);
         const regular: MiniSS = $ss(MiniSSType.REGULAR);
         galaxy = new MEntireGalaxy(
            new Vector.<MapArea>(), [playerHome, allyHome, regular], playerHome);

         assertThat(
            "should return all available solar systems by default",
            galaxy.solarSystems, hasItems (playerHome, allyHome, regular));

         MRenderedSS(galaxy.renderedObjectTypes[2]).rendered = false;
         assertThat(
            "should filter out ALLIANCE_HOME solar systems", galaxy.solarSystems, allOf(
               not (hasItem (allyHome)),
               hasItems (playerHome, regular) ));

         MRenderedSS(galaxy.renderedObjectTypes[1]).rendered = false;
         assertThat(
            "should filter out ALLIANCE_HOME and PLAYER_HOME solar systems",
            galaxy.solarSystems, allOf(
               not (hasItems (allyHome, playerHome)),
               hasItem (regular) ));
      }

      [Test]
      public function renderFowLine(): void {
         assertThat( "fow line should be rendered by default", galaxy.renderFowLine, isTrue() );

         MRenderedFowLine(galaxy.renderedObjectTypes[0]).rendered = false;
         assertThat( "fow line should not be rendered", galaxy.renderFowLine, isFalse() );
      }

      [Test]
      public function fowMatrix(): void {
         function $ss(type: String, x: int, y: int): MiniSS {
            return new MiniSS([x, y], type);
         }

         const playerHome: MiniSS = $ss(MiniSSType.PLAYER_HOME, 1, 1);
         const allyHome: MiniSS = $ss(MiniSSType.ALLIANCE_HOME, 4, 4);
         galaxy = new MEntireGalaxy(
            Vector.<MapArea>([new MapArea(0, 2, 0, 2)]), [playerHome, allyHome], playerHome);


         assertThat(
            "should be built using fow entries and solar systems by default",
            galaxy.fowMatrix.getVisibleBounds(), equals (new MapArea(0, 4, 0, 4)));

         MRenderedFowLine(galaxy.renderedObjectTypes[0]).rendered = false;
         assertThat(
            "should be built using solar systems only if fow line is not rendered",
            galaxy.fowMatrix.getVisibleBounds(), equals (new MapArea(1, 4, 1, 4)));

         MRenderedSS(galaxy.renderedObjectTypes[1]).rendered = false;
         assertThat(
            "should be build using filtered solar systems only",
            galaxy.fowMatrix.getVisibleBounds(), equals (new MapArea(4, 4, 4, 4)));

         MRenderedSS(galaxy.renderedObjectTypes[2]).rendered = false;
         assertThat(
            "should designate empty area if nothing is rendered",
            galaxy.fowMatrix.getVisibleBounds(), equals (new MapArea(0, 0, 0, 0)));
      }
   }
}