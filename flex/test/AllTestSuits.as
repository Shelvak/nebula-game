package
{
   import tests._old.testsuites.ModelsTestSuite;
   import tests._old.testsuites.UtilsTestSuite;
   import tests.animation.TS_Animation;
   import tests.announcement.TS_Announcement;
   import tests.chat.TS_Chat;
   import tests.foliage.TS_Foliage;
   import tests.galaxy.TS_Galaxy;
   import tests.maps.TS_Maps;
   import tests.models.TS_Models;
   import tests.movement.TS_Movement;
   import tests.notifications.TS_Notifications;
   import tests.paging.TS_Paging;
   import tests.planetboss.TS_PlanetBoss;
   import tests.planetcooldown.TS_PlanetCooldown;
   import tests.planetmapeditor.TS_PlanetMapEditor;
   import tests.quests.TS_Quests;
   import tests.spacemap.TS_SpaceMap;
   import tests.time.TS_Time;
   import tests.utils.TS_Utils;
   import tests.utils.components.TS_Components;
   import tests.utils.datastructures.TS_DataStructures;


   public class AllTestSuits
   {
      public function get suits(): Array {
         return [
            TS_Models,
            TS_Animation,
            TS_Notifications,
            TS_Utils,
            TS_DataStructures,
            TS_Components,
            TS_Movement,
            TS_SpaceMap,
            TS_Chat,
            TS_Time,
            TS_Foliage,
            TS_Announcement,
            TS_Galaxy,
            TS_Maps,
            TS_Quests,
            TS_PlanetMapEditor,
            TS_Paging,
            TS_PlanetBoss,
            TS_PlanetCooldown,
            ModelsTestSuite,
            UtilsTestSuite
         ];
      }
   }
}
