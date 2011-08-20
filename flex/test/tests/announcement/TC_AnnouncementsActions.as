package tests.announcement
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import components.announcement.AnnouncementPopup;
   
   import controllers.announcements.AnnouncementsCommand;
   import controllers.announcements.actions.NewAction;
   import controllers.startup.StartupInfo;
   
   import ext.hamcrest.object.equals;
   import ext.mocks.Mock;
   
   import models.announcement.MAnnouncement;
   
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceBundle;
   import mx.resources.ResourceManager;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.date.dateEqual;
   
   import utils.SingletonFactory;
   import utils.assets.ImagePreloader;
   import utils.locale.Locale;
   import utils.locale.Localizer;
   import utils.remote.rmo.ServerRMO;

   public class TC_AnnouncementsActions
   {
      [BeforeClass]
      public static function setUpClass() : void {
         StartupInfo.getInstance().locale = Locale.EN;
         
         var bundleAnnouncements:IResourceBundle = new ResourceBundle(Locale.currentLocale, "Announcements");
         bundleAnnouncements.content["title.popup"] = "";
         bundleAnnouncements.content["label.close"] = "";
         Localizer.addBundle(bundleAnnouncements);
         
         var bundlePopups:IResourceBundle = new ResourceBundle(Locale.currentLocale, "Popups");
         bundlePopups.content["label.confirm"] = "";
         bundlePopups.content["label.cancel"] = "";
         Localizer.addBundle(bundlePopups);
      }
      
      [AfterClass]
      public static function tearDownClass() : void {
         ResourceManager.getInstance().removeResourceBundlesForLocale(Locale.currentLocale);
      }
      
      
      [Rule]
      public var includeMocks:IncludeMocksRule = new IncludeMocksRule([ImagePreloader, AnnouncementPopup]);
      private var repository:MockRepository;
      
      
      [Before]
      public function setUp() : void {         
         repository = new MockRepository();
         Mock.singleton(repository, ImagePreloader, Mock.TYPE_STUB);
         Mock.singleton(repository, AnnouncementPopup, Mock.TYPE_STRICT);
      }
      
      [After]
      public function tearDown() : void {
         repository = null;
         SingletonFactory.clearAllSingletonInstances();
      }
      
      [Test]
      public function newActionUpdatesAnnouncementSingletonAndShowsPopup() : void {
         var announcement:MAnnouncement = MAnnouncement.getInstance();
         var popup:AnnouncementPopup = AnnouncementPopup.getInstance();
         var newAction:NewAction = new NewAction();
         
         var rmo:ServerRMO = new ServerRMO();
         rmo.action = AnnouncementsCommand.NEW;
         rmo.parameters = {
            "message": "Server shutdown",
            "endsAt": "2000-01-01T00:00:00Z"
         };
         
         Expect.call(popup.show());
         repository.replay(popup);
         newAction.applyAction(new AnnouncementsCommand(rmo.action, rmo.parameters, true, false, rmo));
         repository.verify(popup);
         
         var endsAt:Date = new Date();
         endsAt.setUTCFullYear(2000, 0, 1);
         endsAt.setUTCHours(0, 0, 0, 0);
         assertThat( "announcement.message updated", announcement.message, equals ("Server shutdown") );
         assertThat( "announcement.event updated", announcement.event.occuresAt, dateEqual (endsAt) );
      }
   }
}