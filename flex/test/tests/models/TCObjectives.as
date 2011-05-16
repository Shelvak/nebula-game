package tests.models
{
   import config.Config;
   
   import models.objectives.HaveUpgradedTo;
   import models.objectives.ObjectiveType;
   import models.objectives.UpgradeTo;
   
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
//         haveUpgradedTo = new HaveUpgradedTo();
//         upgradeTo = new UpgradeTo();
      }
      
      [Ignore("Does not compile!")]
      [Test]
      public function testUpgradeObjectives() : void
      {
         haveUpgradedTo.objective.level = 5;
         haveUpgradedTo.objective.type = ObjectiveType.HAVE_UPGRADED_TO;
         haveUpgradedTo.objective.count = 3;
//         haveUpgradedTo.completed = 1;
         haveUpgradedTo.objective.key = 'unit::Seeker';
         
         upgradeTo.objective.level = 1;
         upgradeTo.objective.type = ObjectiveType.UPGRADE_TO;
         upgradeTo.objective.count = 5;
//         upgradeTo.completed = 2;
         upgradeTo.objective.key = 'unit::Trooper';
         assertThat(haveUpgradedTo.objectiveText, equalTo("Have 3 Seekers of level 5 (1/3)"));
         assertThat(upgradeTo.objectiveText, equalTo("Build 5 Troopers (2/5)"));
         
         haveUpgradedTo.objective.level = 1;
         upgradeTo.objective.level = 4;
         haveUpgradedTo.objective.count = 1;
         upgradeTo.objective.count = 1;
//         upgradeTo.completed = 0;
         assertThat(haveUpgradedTo.objectiveText, equalTo("Have 1 Seeker (1/1)"));
         assertThat(upgradeTo.objectiveText, equalTo("Upgrade 1 Trooper to level 4 (0/1)"));
      }
   }
}