package components.notifications.parts
{
   import components.base.ImageAndLabel;
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.CombatLogAlliance;
   import components.notifications.parts.skins.CombatLogGrid;
   import components.notifications.parts.skins.CombatLogSkin;
   
   import controllers.Messenger;
   import controllers.startup.StartupInfo;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.System;
   
   import models.ModelLocator;
   import models.notification.parts.CombatLog;
   import models.notification.parts.CombatOutcomeType;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.Button;
   import spark.components.DataGroup;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.TextInput;
   
   import utils.locale.Localizer;
   
   
   public class IRCombatLog extends IRNotificationPartBase
   {
      private static const STATUS_COLORS: Array = ['0x00ff00', '0xff0000', '0xffffff'];
      
      private static const CLASSIFICATION_FRIEND: int = 0;
      private static const CLASSIFICATION_ENEMY: int = 1;
      private static const CLASSIFICATION_NAP: int = 2;

      private static const STATUS_ORDER: Array = [CLASSIFICATION_FRIEND, CLASSIFICATION_NAP, CLASSIFICATION_ENEMY];
      
      
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      public function IRCombatLog()
      {
         super();
         setStyle("skinClass", CombatLogSkin);
      }
      
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [Bindable]
      public var hasSelfUnits: Boolean = false;
      [Bindable]
      public var hasAllyUnits: Boolean = false;
      [Bindable]
      public var hasNapUnits: Boolean = false;
      [Bindable]
      public var hasEnemyUnits: Boolean = false;
      
      
      [SkinPart(required="true")]
      public var selfAlive:CombatLogGrid;
      private function setSelfAliveInfo() : void
      {
         if (selfAlive)
         {
            selfAlive.list = combatLog == null ? null : myAliveList;
            hasSelfUnits = (myAliveList.length > 0) || (myDestroyedList.length > 0);
            dispatchColumnsChangeEvent();
         }
      }
      
      
      [SkinPart(required="true")]
      public var allyAlive:CombatLogGrid;
      private function setAllyAliveInfo() : void
      {
         if (allyAlive)
         {
            allyAlive.list = combatLog == null ? null : allianceAliveList;
            hasAllyUnits = (allianceAliveList.length > 0) || (allianceDestroyedList.length > 0);
            dispatchColumnsChangeEvent();
         }
      }
      
      
      [SkinPart(required="true")]
      public var napAlive:CombatLogGrid;
      private function setNapAliveInfo() : void
      {
         if (napAlive)
         {
            napAlive.list = combatLog == null ? null : napAliveList;
            hasNapUnits = (napAliveList.length > 0) || (napDestroyedList.length > 0);
            dispatchColumnsChangeEvent();
         }
      }
      
      
      [SkinPart(required="true")]
      public var enemyAlive:CombatLogGrid;
      private function setEnemyAliveInfo() : void
      {
         if (enemyAlive)
         {
            enemyAlive.list = combatLog == null ? null : enemyAliveList;
            hasEnemyUnits = (enemyAliveList.length > 0) || (enemyDestroyedList.length > 0);
            dispatchColumnsChangeEvent();
         }
      }
      
      
      [SkinPart(required="true")]
      public var selfDestroyed:CombatLogGrid;
      private function setSelfDestroyedInfo() : void
      {
         if (selfDestroyed)
         {
            selfDestroyed.list = combatLog == null ? null : myDestroyedList;
            hasSelfUnits = (myAliveList.length > 0) || (myDestroyedList.length > 0);
            dispatchColumnsChangeEvent();
         }
      }
      
      
      [SkinPart(required="true")]
      public var allyDestroyed:CombatLogGrid;
      private function setAllyDestroyedInfo() : void
      {
         if (allyDestroyed)
         {
            allyDestroyed.list = combatLog == null ? null : allianceDestroyedList;
            hasAllyUnits = (allianceAliveList.length > 0) || (allianceDestroyedList.length > 0);
            dispatchColumnsChangeEvent();
         }
      }
      
      
      [SkinPart(required="true")]
      public var napDestroyed:CombatLogGrid;
      private function setNapDestroyedInfo() : void
      {
         if (napDestroyed)
         {
            napDestroyed.list = combatLog == null ? null : napDestroyedList;
            hasNapUnits = (napAliveList.length > 0) || (napDestroyedList.length > 0);
            dispatchColumnsChangeEvent();
         }
      }
      
      
      [SkinPart(required="true")]
      public var enemyDestroyed:CombatLogGrid;
      private function setEnemyDestroyedInfo() : void
      {
         if (enemyDestroyed)
         {
            enemyDestroyed.list = combatLog == null ? null : enemyDestroyedList;
            hasEnemyUnits = (enemyAliveList.length > 0) || (enemyDestroyedList.length > 0);
            dispatchColumnsChangeEvent();
         }
      }
      
      
      private function dispatchColumnsChangeEvent(): void
      {
         dispatchEvent(new Event("unitColumnsChange"));
      }
      
      
      [SkinPart(required="true")]
      public var lblLeveled:Label;
      private function setLblLeveledText() : void
      {
         if (lblLeveled)
         {
            lblLeveled.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.leveled');
         }
      }
      
      
      [SkinPart(required="true")]
      public var lblStats:Label;
      private function setLblStatsText() : void
      {
         if (lblStats)
         {
            lblStats.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.stats');
         }
      }
      
      
      [SkinPart(required="true")]
      public var leveledList:DataGroup;
      private function setLeveledInfo() : void
      {
         if (leveledList)
         {
            leveledList.dataProvider = combatLog.leveledUp;
         }
      }
      
      
      [SkinPart(required="true")]
      public var outcomeIndicator:CombatOutcome;
      private function setOutcomeIndicatorOutcome(): void
      {
         if (outcomeIndicator)
         {
            outcomeIndicator.outcome = combatLog.outcome;
         }
      }
      
      
      [SkinPart(required="true")]
      public var outcomeLabel:Label;
      private function setOutcomeLabelText() : void
      {
         if (outcomeLabel)
         {
            switch (combatLog.outcome)
            {
               case CombatOutcomeType.WIN:
                  outcomeLabel.text = getString("label.combatLog.outcome.win");
                  break;
               
               case CombatOutcomeType.LOOSE:
                  outcomeLabel.text = getString("label.combatLog.outcome.loose");
                  break;
               
               default:
                  outcomeLabel.text = getString("label.combatLog.outcome.tie");
            }
         }
      }
      
      
      [SkinPart (required="true")]
      public var location:MiniLocationComp;
      private function setLocationModel() : void
      {
         if (location)
         {
            location.location = combatLog.location;
         }
      }
      
      
      [SkinPart (required="true")]
      public var btnShowLog:Button;
      private function setBtnShowLogInfo() : void
      {
         if (btnShowLog)
         {
            btnShowLog.label = combatLog == null ? "" : getString("label.combatLog.showLog");
            if (combatLog != null)
               btnShowLog.addEventListener(MouseEvent.CLICK, showLog);
         }
      }
      
      
      private function get combatLogUrl() : String
      {
         var info:StartupInfo = StartupInfo.getInstance();
         return ExternalInterface.call("getCombatLogUrl",
            combatLog.logId, ML.player.id, info.server, info.webHost,
            StartupInfo.getInstance().locale);
      }
      
      
      private function showLog(e: Event): void
      {
         navigateToURL(new URLRequest(combatLogUrl), "_blank");
      }
      
      [SkinPart(required="true")]
      public var lblDmgDealtPlayer:Label;
      
      
      private function setLblDmgDealtPlayerText() : void
      {
         if (lblDmgDealtPlayer)
         {
            lblDmgDealtPlayer.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.dmgDealtPlayer');
         }
      }
      
      [SkinPart(required="true")]
      public var lblDmgDealtAlliance:Label;
      
      
      private function setLblDmgDealtAllianceText() : void
      {
         if (lblDmgDealtAlliance)
         {
            lblDmgDealtAlliance.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.dmgDealtAlliance');
            lblDmgDealtAlliance.visible = (combatLog == null) ||
               (combatLog.damageDealtAlliance != combatLog.damageDealtPlayer);
         }
      }
      
      [SkinPart(required="true")]
      public var lblDmgTakenPlayer:Label;
      
      
      private function setLblDmgTakenPlayerText() : void
      {
         if (lblDmgTakenPlayer)
         {
            lblDmgTakenPlayer.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.dmgTakenPlayer');
         }
      }
      
      [SkinPart(required="true")]
      public var lblDmgTakenAlliance:Label;
      
      
      private function setLblDmgTakenAllianceText() : void
      {
         if (lblDmgTakenAlliance)
         {
            lblDmgTakenAlliance.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.dmgTakenAlliance');
            lblDmgTakenAlliance.visible = (combatLog == null) ||
               (combatLog.damageTakenAlliance != combatLog.damageTakenPlayer);
         }
      }
      
      [SkinPart(required="true")]
      public var lblXp:Label;
      
      
      private function setLblXpText() : void
      {
         if (lblXp)
         {
            lblXp.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.xp');
         }
      }
      
      [SkinPart(required="true")]
      public var lblPoints:Label;
      
      
      private function setLblPointsText() : void
      {
         if (lblPoints)
         {
            lblPoints.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.points');
         }
      }
      
      [SkinPart(required="true")]
      public var lblPlayers:Label;
      
      
      private function setLblPlayersText() : void
      {
         if (lblPlayers)
         {
            lblPlayers.text = combatLog == null ? "" :
               Localizer.string('Notifications', 'label.players');
         }
      }
      
      [SkinPart(required="true")]
      public var valDmgDealtPlayer:Label;
      
      
      private function setValDmgDealtPlayerText() : void
      {
         if (valDmgDealtPlayer)
         {
            valDmgDealtPlayer.text = combatLog == null ? "" : combatLog.damageDealtPlayer.toString();
         }
      }
      
      
      [SkinPart(required="true")]
      public var valDmgDealtAlliance:Label;
      
      
      private function setValDmgDealtAllianceText() : void
      {
         if (valDmgDealtAlliance)
         {
            valDmgDealtAlliance.text = combatLog == null ? "" : combatLog.damageDealtAlliance.toString();
            valDmgDealtAlliance.visible = (combatLog == null) ||
               (combatLog.damageDealtAlliance != combatLog.damageDealtPlayer);
         }
      }
      
      [SkinPart(required="true")]
      public var valDmgTakenPlayer:Label;
      
      
      private function setValDmgTakenPlayerText() : void
      {
         if (valDmgTakenPlayer)
         {
            valDmgTakenPlayer.text = combatLog == null ? "" : combatLog.damageTakenPlayer.toString();
         }
      }
      
      [SkinPart(required="true")]
      public var valDmgTakenAlliance:Label;
      
      
      private function setValDmgTakenAllianceText() : void
      {
         if (valDmgTakenAlliance)
         {
            valDmgTakenAlliance.text = combatLog == null ? "" : combatLog.damageTakenAlliance.toString();
            valDmgTakenAlliance.visible = (combatLog == null) ||
               (combatLog.damageTakenAlliance != combatLog.damageTakenPlayer);
         }
      }
      
      [SkinPart(required="true")]
      public var valXp:Label;
      
      
      private function setValXpText() : void
      {
         if (valXp)
         {
            valXp.text = combatLog == null ? "" : combatLog.xpEarned.toString();
         }
      }
      
      [SkinPart(required="true")]
      public var valPoints:Label;
      
      
      private function setValPointsText() : void
      {
         if (valPoints)
         {
            valPoints.text = combatLog == null ? "" : combatLog.pointsEarned.toString();
         }
      }
      
      [SkinPart(required="true")]
      public var metalLeft:ImageAndLabel;
      [SkinPart(required="true")]
      public var energyLeft:ImageAndLabel;
      [SkinPart(required="true")]
      public var zetiumLeft:ImageAndLabel;
      [SkinPart(required="true")]
      public var lblResLeft:Label;
      
      
      [SkinPart(required="true")]
      public var txtLogUrl:TextInput;
      
      
      [SkinPart(required="true")]
      public var btnCopyLogUrlToClipboard:Button;
      
      
      private function setWreckage() : void
      {
         if (metalLeft && energyLeft && zetiumLeft && lblResLeft)
         {
            if (combatLog.location.isSSObject)
            {
               lblResLeft.text = Localizer.string('Notifications','label.resourcesGained');
            }
            else
            {
               lblResLeft.text = Localizer.string('Notifications','label.wreckageLeft');
            }
            metalLeft.textToDisplay = combatLog.metal.toString();
            energyLeft.textToDisplay = combatLog.energy.toString();
            zetiumLeft.textToDisplay = combatLog.zetium.toString();
         }
      }
      
      [SkinPart(required="true")]
      public var allianceTable:Group;
      
      
      private function setAllianceTableInfo() : void
      {
         if (allianceTable)
         {
            var noAlly: CombatLogAlliance = null;
            for each (var i: int in STATUS_ORDER)
            {
               for (var key: String in combatLog.alliancePlayers)
               {
                  if (combatLog.alliancePlayers[key].classification == i)
                  {
                     var alliance: Object = combatLog.alliancePlayers[key];
                     var tempAllianceComp: CombatLogAlliance;
                     if (key.charAt(0) == '-')
                     {
                        if (noAlly == null)
                        {
                           noAlly = new CombatLogAlliance();
                           allianceTable.addElement(noAlly);
                        }
                        tempAllianceComp = noAlly;
                        noAlly.alliance = Localizer.string('Players', 'noAlliance');
                        tempAllianceComp.headerColor = STATUS_COLORS[CLASSIFICATION_NAP];
                        tempAllianceComp.addPlayers(alliance.players, STATUS_COLORS[alliance.classification]);
                     }
                     else
                     {
                        tempAllianceComp = new CombatLogAlliance();
                        tempAllianceComp.alliance = alliance.name;
                        tempAllianceComp.headerColor = STATUS_COLORS[alliance.classification];
                        tempAllianceComp.addPlayers(alliance.players, STATUS_COLORS[CLASSIFICATION_NAP]);
                        allianceTable.addElement(tempAllianceComp);
                     }
                  }
               }
            }
         }
      }
      
      [Bindable (event="unitColumnsChange")]
      public function getGridCollumnWidth(total: Number): Number
      {
         var collumnCount: int = 0;
         if (hasSelfUnits) collumnCount++;
         if (hasAllyUnits) collumnCount++;
         if (hasNapUnits) collumnCount++;
         if (hasEnemyUnits) collumnCount++;
         return (total - 86)/collumnCount;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get combatLog() : CombatLog
      {
         return notificationPart as CombatLog;
      }
      
      
      //Array collections of units
      //==================================================
      private function get myAliveList(): ArrayCollection
      {
         if (combatLog == null)
         {
            return null;  
         }
         else
         {
            var tArrayCol: ArrayCollection = new ArrayCollection();
            for (var unit: String in combatLog.units.yours.alive)
               tArrayCol.addItem(new UnitBuildingEntry(unit, combatLog.units.yours.alive[unit]));
            
            return tArrayCol;
         }
      }
      
      private function get myDestroyedList(): ArrayCollection
      {
         if (combatLog == null)
         {
            return new ArrayCollection();  
         }
         else
         {
            var tArrayCol: ArrayCollection = new ArrayCollection();
            for (var unit: String in combatLog.units.yours.dead)
               tArrayCol.addItem(new UnitBuildingEntry(unit, combatLog.units.yours.dead[unit]));
            
            return tArrayCol;
         }
      }
      
      private function get allianceAliveList(): ArrayCollection
      {
         if (combatLog == null)
         {
            return new ArrayCollection();
         }
         else
         {
            var tArrayCol: ArrayCollection = new ArrayCollection();
            for (var unit: String in combatLog.units.alliance.alive)
               tArrayCol.addItem(new UnitBuildingEntry(unit, combatLog.units.alliance.alive[unit]));
            
            return tArrayCol;
         }
      }
      
      private function get allianceDestroyedList(): ArrayCollection
      {
         if (combatLog == null)
         {
            return new ArrayCollection();
         }
         else
         {
            var tArrayCol: ArrayCollection = new ArrayCollection();
            for (var unit: String in combatLog.units.alliance.dead)
               tArrayCol.addItem(new UnitBuildingEntry(unit, combatLog.units.alliance.dead[unit]));
            
            return tArrayCol;
         }
      }
      
      private function get napAliveList(): ArrayCollection
      {
         if (combatLog == null)
         {
            return new ArrayCollection();
         }
         else
         {
            var tArrayCol: ArrayCollection = new ArrayCollection();
            for (var unit: String in combatLog.units.nap.alive)
               tArrayCol.addItem(new UnitBuildingEntry(unit, combatLog.units.nap.alive[unit]));
            
            return tArrayCol;
         }
      }
      
      private function get napDestroyedList(): ArrayCollection
      {
         if (combatLog == null)
         {
            return new ArrayCollection();
         }
         else
         {
            var tArrayCol: ArrayCollection = new ArrayCollection();
            for (var unit: String in combatLog.units.nap.dead)
               tArrayCol.addItem(new UnitBuildingEntry(unit, combatLog.units.nap.dead[unit]));
            
            return tArrayCol;
         }
      }
      
      private function get enemyAliveList(): ArrayCollection
      {
         if (combatLog == null)
         {
            return new ArrayCollection();
         }
         else
         {
            var tArrayCol: ArrayCollection = new ArrayCollection();
            for (var unit: String in combatLog.units.enemy.alive)
               tArrayCol.addItem(new UnitBuildingEntry(unit, combatLog.units.enemy.alive[unit]));
            
            return tArrayCol;
         }
      }
      
      private function get enemyDestroyedList(): ArrayCollection
      {
         if (combatLog == null)
         {
            return new ArrayCollection();
         }
         else
         {
            var tArrayCol: ArrayCollection = new ArrayCollection();
            for (var unit: String in combatLog.units.enemy.dead)
               tArrayCol.addItem(new UnitBuildingEntry(unit, combatLog.units.enemy.dead[unit]));
            
            return tArrayCol;
         }
      }
      //==================================================
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            setSelfAliveInfo();
            setAllyAliveInfo();
            setNapAliveInfo();
            setEnemyAliveInfo();
            setSelfDestroyedInfo();
            setAllyDestroyedInfo();
            setNapDestroyedInfo();
            setEnemyDestroyedInfo();
            setOutcomeIndicatorOutcome();
            setOutcomeLabelText();
            setLeveledInfo();
            setLblLeveledText();
            setLocationModel();
            setBtnShowLogInfo();
            setLblDmgDealtPlayerText();
            setLblDmgDealtAllianceText();
            setLblDmgTakenPlayerText();
            setLblDmgTakenAllianceText();
            setLblXpText();
            setValXpText();
            setLblPlayersText();
            setLblPointsText();
            setAllianceTableInfo();
            setValDmgDealtPlayerText();
            setValDmgDealtAllianceText();
            setValDmgTakenPlayerText();
            setValDmgTakenAllianceText();
            setValPointsText();
            setLblStatsText();
            setWreckage();
            txtLogUrl.text = combatLogUrl;
            btnCopyLogUrlToClipboard.label = getString("label.combatLog.copyToClipboard");
            btnCopyLogUrlToClipboard.addEventListener(MouseEvent.CLICK, btnCopyLogUrlToClipboard_clickHandler,
                                                      false, 0, true);
         }
         f_NotificationPartChange = false;
      }
      
      
      private function getString(property:String, parameters:Array = null) : String
      {
         return Localizer.string("Notifications", property, parameters);
      }
      
      
      /* ################################# */
      /* ### COMPONENTS EVENT HANDLERS ### */
      /* ################################# */
      
      private function btnCopyLogUrlToClipboard_clickHandler(event:MouseEvent) : void
      {
         System.setClipboard(combatLogUrl);
         Messenger.show(Localizer.string("General", "message.copyToClipboardSuccessful"), Messenger.MEDIUM);
      }
   }
}
