package tests.models.tests
{
   import config.Config;
   
   import models.quest.HaveUpgradedTo;
   import models.quest.ObjectiveType;
   import models.quest.UpgradeTo;
   
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceBundle;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   
   public class TCObjectives
   {
      private var haveUpgradedTo: HaveUpgradedTo;
      private var upgradeTo: UpgradeTo;
      
      [Before]
      public function setUp() : void
      {
         haveUpgradedTo = new HaveUpgradedTo();
         upgradeTo = new UpgradeTo();
      }
      
      [Test]
      public function testUpgradeObjectives() : void
      {
         haveUpgradedTo.level = 5;
         haveUpgradedTo.type = ObjectiveType.HAVE_UPGRADED_TO;
         haveUpgradedTo.count = 3;
         haveUpgradedTo.completed = 1;
         haveUpgradedTo.key = 'unit::Seeker';
         
         upgradeTo.level = 1;
         upgradeTo.type = ObjectiveType.UPGRADE_TO;
         upgradeTo.count = 5;
         upgradeTo.completed = 2;
         upgradeTo.key = 'unit::Trooper';
         assertThat(haveUpgradedTo.objectiveText, equalTo("Have 3 Seekers of level 5 (1/3)"));
         assertThat(upgradeTo.objectiveText, equalTo("Build 5 Troopers (2/5)"));
         
         haveUpgradedTo.level = 1;
         upgradeTo.level = 4;
         haveUpgradedTo.count = 1;
         upgradeTo.count = 1;
         upgradeTo.completed = 0;
         assertThat(haveUpgradedTo.objectiveText, equalTo("Have 1 Seeker (1/1)"));
         assertThat(upgradeTo.objectiveText, equalTo("Upgrade 1 Trooper to level 4 (0/1)"));
      }
   }
}