package tests.models
{
   import config.Config;
   
   import models.objectives.HaveUpgradedTo;
   import models.objectives.Objective;
   import models.objectives.ObjectiveType;
   import models.objectives.QuestObjective;
   import models.objectives.UpgradeTo;
   
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceBundle;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   
   import utils.locale.Locale;
   import utils.locale.Localizer;
   
   public class TC_Objectives
   {
      private var haveUpgradedTo: QuestObjective;
      private var upgradeTo: QuestObjective;
      
      [Before]
      public function setUp() : void
      {
         haveUpgradedTo = new QuestObjective(ObjectiveType.HAVE_UPGRADED_TO);
         with (haveUpgradedTo)
         {
            level = 5;
            count = 3;
            completed = 1;
            key = 'unit::Seeker';
         }
         upgradeTo = new QuestObjective(ObjectiveType.UPGRADE_TO);
         with (upgradeTo)
         {
            level = 1;
            count = 5;
            completed = 2;
            key = 'unit::Trooper';
         }
         
         var bundle: ResourceBundle = new ResourceBundle(Locale.EN, 'Objects');
         bundle.content['Trooper'] = 'Trooper';
         bundle.content['Trooper-p8d'] = '{0 one[one trooper] many[? troopers]}';
         bundle.content['Seeker'] = 'Seeker';
         bundle.content['Seeker-p8d'] = '{0 one[one seeker] many[? seekers]}';
         
         
         
         var bundle2: ResourceBundle = new ResourceBundle(Locale.EN, 'Objectives');
         bundle2.content['objectiveText.HaveUpgradedTo'] = 'Have [obj:{0}:{1}:p8d]{2 one[] many[ of level ?]}';
         bundle2.content['objectiveText.UpgradeTo'] = '{2 one[Build] many[Upgrade]} [obj:{0}:{1}:p8d]{2 one[] many[ to level ?]}';
         Localizer.addBundle(bundle);
         Localizer.addBundle(bundle2);
      }
      
      [Test]
      public function testUpgradeObjectives() : void
      {
         assertThat(haveUpgradedTo.objectiveText, equalTo("Have 3 seekers of level 5 (1/3)"));
         assertThat(upgradeTo.objectiveText, equalTo("Build 5 troopers (2/5)"));
         
         haveUpgradedTo.level = 1;
         upgradeTo.level = 4;
         haveUpgradedTo.count = 1;
         upgradeTo.count = 1;
         upgradeTo.completed = 0;
         assertThat(haveUpgradedTo.objectiveText, equalTo("Have one seeker (1/1)"));
         assertThat(upgradeTo.objectiveText, equalTo("Upgrade one trooper to level 4 (0/1)"));
      }
   }
}