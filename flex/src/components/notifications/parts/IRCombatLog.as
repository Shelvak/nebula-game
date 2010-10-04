package components.notifications.parts
{
   import components.location.CLocation;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.CombatLogAlliance;
   import components.notifications.parts.skins.CombatLogGrid;
   import components.notifications.parts.skins.CombatLogSkin;
   
   import controllers.ui.NavigationController;
   
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   import models.notification.parts.CombatLog;
   import models.notification.parts.CombatLogItem;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   import mx.controls.AdvancedDataGrid;
   import mx.controls.DataGrid;
   
   import spark.components.Button;
   import spark.components.DataGroup;
   import spark.components.Group;
   import spark.components.Label;
   
   
   [ResourceBundle("Notifications")]
   [ResourceBundle("Players")]
   
   
   public class IRCombatLog extends IRNotificationPartBase
   {
      private static const STATUS_COLORS: Array = ['0x00ff00', '0xff0000', '0xffffff'];
      
      private static const STATUS_ORDER: Array = [0, 2, 1];
      
      
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
               resourceManager.getString('Notifications', 'label.leveled');
         }
      }
      
      
      [SkinPart(required="true")]
      public var lblStats:Label;
      
      
      private function setLblStatsText() : void
      {
         if (lblStats)
         {
            lblStats.text = combatLog == null ? "" :
               resourceManager.getString('Notifications', 'label.stats');
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
      
      [SkinPart (required="true")]
      public var location:CLocation;
      
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
            btnShowLog.label = combatLog == null ? "" :
               resourceManager.getString('Notifications', 'label.showLog');
            if (combatLog != null)
               btnShowLog.addEventListener(MouseEvent.CLICK, showLog);
         }
      }
      
      private function showLog(e: Event): void
      {
         NavigationController.getInstance().toBattle(combatLog.logId);
      }
      
      [SkinPart(required="true")]
      public var lblDmgDealtPlayer:Label;
      
      
      private function setLblDmgDealtPlayerText() : void
      {
         if (lblDmgDealtPlayer)
         {
            lblDmgDealtPlayer.text = combatLog == null ? "" :
               resourceManager.getString('Notifications', 'label.dmgDealtPlayer');
         }
      }
      
      [SkinPart(required="true")]
      public var lblDmgDealtAlliance:Label;
      
      
      private function setLblDmgDealtAllianceText() : void
      {
         if (lblDmgDealtAlliance)
         {
            lblDmgDealtAlliance.text = combatLog == null ? "" :
               resourceManager.getString('Notifications', 'label.dmgDealtAlliance');
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
               resourceManager.getString('Notifications', 'label.dmgTakenPlayer');
         }
      }
      
      [SkinPart(required="true")]
      public var lblDmgTakenAlliance:Label;
      
      
      private function setLblDmgTakenAllianceText() : void
      {
         if (lblDmgTakenAlliance)
         {
            lblDmgTakenAlliance.text = combatLog == null ? "" :
               resourceManager.getString('Notifications', 'label.dmgTakenAlliance');
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
               resourceManager.getString('Notifications', 'label.xp');
         }
      }
      
      [SkinPart(required="true")]
      public var lblPoints:Label;
      
      
      private function setLblPointsText() : void
      {
         if (lblPoints)
         {
            lblPoints.text = combatLog == null ? "" :
               resourceManager.getString('Notifications', 'label.points');
         }
      }
      
      [SkinPart(required="true")]
      public var lblPlayers:Label;
      
      
      private function setLblPlayersText() : void
      {
         if (lblPlayers)
         {
            lblPlayers.text = combatLog == null ? "" :
               resourceManager.getString('Notifications', 'label.players');
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
      public var allianceTable:Group;
      
      
      private function setAllianceTableInfo() : void
      {
         if (allianceTable)
         {
            for each (var i: int in STATUS_ORDER)
            {
               for (var key: String in combatLog.alliancePlayers)
               {
                  if (combatLog.alliancePlayers[key].classification == i)
                  {
                     var alliance: Object = combatLog.alliancePlayers[key];
                     var tempAllianceComp: CombatLogAlliance = new CombatLogAlliance();
                     tempAllianceComp.alliance = key.charAt(0) == '-'?resourceManager.getString('Players', 'noAlliance'):alliance.name;
                     if (tempAllianceComp.alliance == '-2')
                     {
                        tempAllianceComp.alliance = resourceManager.getString('Players', 'noAlliance');
                     }
                     else if (tempAllianceComp.alliance == '-1')
                     {
                        tempAllianceComp.alliance = resourceManager.getString('Players', 'noAlliance');
                     }
                     tempAllianceComp.addPlayers(alliance.players);
                     tempAllianceComp.headerColor = STATUS_COLORS[alliance.classification];
                     allianceTable.addElement(tempAllianceComp);
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
      
      protected override function partAdded(partName:String, instance:Object):void
      {
         super.partAdded(partName, instance);
         switch(instance)
         {
            case selfAlive:
               setSelfAliveInfo();
               break;
            
            case allyAlive:
               setAllyAliveInfo();
               break;
            
            case napAlive:
               setNapAliveInfo();
               break;
            
            case enemyAlive:
               setEnemyAliveInfo();
               break;
            
            case selfDestroyed:
               setSelfDestroyedInfo();
               break;
            
            case allyDestroyed:
               setAllyDestroyedInfo();
               break;
            
            case napDestroyed:
               setNapDestroyedInfo();
               break;
            
            case enemyDestroyed:
               setEnemyDestroyedInfo();
               break;
            
            case outcomeIndicator:
               setOutcomeIndicatorOutcome();
               break;
            
            case leveledList:
               setLeveledInfo();
               break;
            
            case lblLeveled:
               setLblLeveledText();
               break;
            
            case location:
               setLocationModel();
               break;
            
            case lblDmgDealtPlayer:
               setLblDmgDealtPlayerText();
               break;
            
            case lblDmgDealtAlliance:
               setLblDmgDealtAllianceText();
               break;
            
            case lblDmgTakenPlayer:
               setLblDmgTakenPlayerText();
               break;
            
            case lblDmgTakenAlliance:
               setLblDmgTakenAllianceText();
               break;
            
            case lblXp:
               setLblXpText();
               break;
            
            case lblPoints:
               setLblPointsText();
               break;
            
            case lblPlayers:
               setLblPlayersText();
               break;
            
            case valDmgDealtPlayer:
               setValDmgDealtPlayerText();
               break;
            
            case valDmgDealtAlliance:
               setValDmgDealtAllianceText();
               break;
            
            case valDmgTakenPlayer:
               setValDmgTakenPlayerText();
               break;
            
            case valDmgTakenAlliance:
               setValDmgTakenAllianceText();
               break;
            
            case valXp:
               setValXpText();
               break;
            
            case valPoints:
               setValPointsText();
               break;
            
            case lblStats:
               setLblStatsText();
               break;
            
            case btnShowLog:
               setBtnShowLogInfo();
               break;
            
            case allianceTable:
               setAllianceTableInfo();
               break;
            
         }
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
         if (fNotificationPartChange)
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
            setLeveledInfo();
            setLblLeveledText();
            setLocationModel();
            setLblDmgDealtPlayerText();
            setLblDmgDealtAllianceText();
            setLblDmgTakenPlayerText();
            setLblDmgTakenAllianceText();
            setLblXpText();
            setLblPointsText();
            setValDmgDealtPlayerText();
            setValDmgDealtAllianceText();
            setValDmgTakenPlayerText();
            setValDmgTakenAllianceText();
            setValPointsText();
            setLblStatsText();
         }
         fNotificationPartChange = false;
      }
   }
}