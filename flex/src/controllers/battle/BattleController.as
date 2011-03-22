package controllers.battle
{
   import animation.AnimationTimer;
   import animation.events.AnimatedBitmapEvent;
   
   import com.developmentarc.core.utils.EventBroker;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   
   import components.base.viewport.ViewportZoomable;
   import components.battle.BBattleParticipantComp;
   import components.battle.BBuildingComp;
   import components.battle.BFoliageComp;
   import components.battle.BProjectileComp;
   import components.battle.BUnitComp;
   import components.battle.BattleMap;
   import components.battle.DamageBubble;
   import components.factories.MapFactory;
   import components.map.controllers.IMapViewportController;
   
   import config.BattleConfig;
   
   import controllers.screens.ScreensSwitch;
   import controllers.ui.NavigationController;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   import models.IMBattleParticipant;
   import models.Owner;
   import models.battle.BFlank;
   import models.battle.BGun;
   import models.battle.BOverallHp;
   import models.battle.BProjectile;
   import models.battle.BUnit;
   import models.battle.Battle;
   import models.battle.FireOrder;
   import models.battle.FireOrderPart;
   import models.battle.events.BattleControllerEvent;
   import models.factories.BattleFactory;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.core.AdvancedLayoutFeatures;
   import mx.core.IVisualElement;
   
   import spark.components.NavigatorContent;
   
   import utils.ClassUtil;
   import utils.MathUtil;
   
   
   public class BattleController
   {
      private static var _battleController:BattleController;
      private static var _battleId:String;
      public static function showBattle(logId:String, log:Object) : void
      {
         _battleId = logId;
         var seed:uint = uint('0x' + logId.slice(logId.length - 9, logId.length - 1));
         var battle:Battle = BattleFactory.fromObject(log, seed);
         var viewport:ViewportZoomable = MapFactory.getViewportWithMap(battle);
         var viewportCtrl:IMapViewportController = MapFactory.getViewportController(battle);
         if (_battleController)
         {
            _battleController.cleanup();
         }
         _battleController = new BattleController(battle, BattleMap(viewport.content));
         
         var content:NavigatorContent = ScreensSwitch.getInstance().currentScreenContent;
         if (content.numElements > 0)
         {
            ViewportZoomable(content.getElementAt(0)).cleanup();
         }
         if (content.numElements > 1)
         {
            IMapViewportController(content.getElementAt(1)).cleanup();
         }
         content.removeAllElements();
         content.addElement(viewport);
         if (viewportCtrl != null)
         {
            content.addElement(viewportCtrl);
         }
      }
      
      
      private static const NORM_X:Vector3D = new Vector3D(1, 0);
      private static const NORM_Y:Vector3D = new Vector3D(0, 1)
      
      
      /**
       * Default speed of animation measured in fps.
       */
      public static const DEFAULT_FPS:int = 1000/AnimationTimer.DEFAULT_BATTLE_ANIM_DELAY;
      
      
      private var fps: int = DEFAULT_FPS;
      /**
       * Minimum speed of animation measured in fps.
       */
      public static const MIN_FPS:int = 2;
      
      
      
      
      
      /**
       * Maximum speed of animation measured in fps.
       */
      public static const MAX_FPS:int = 80;
      
      private static const FPS_STEP:int = 6;
      
      private static const SWINGING_FOLLIAGES: int = 5;
      
      
      /**
       * time delay betwean two grouped unitComps fire orders
       */      
      private static const GROUP_DELAY: int = 500;
      
      private static const UNITS_MOVE_DELAY: int = 100;
      
      private static const FOLLIAGE_SWING_DELAY: int = 1000;
      
      private static const EMOTION_CHANCE: Number = 0.3;
      
      private static const DAMAGE_BUBBLE_DURATION: Number = 0.8;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      private var _timer:AnimationTimer = null;
      private var _battle:Battle = null;
      private var _battleMap:BattleMap = null;
      private var _log:ArrayCollection = null;
      
      public var outcome: int = 0;
      
      
      [Bindable]
      public var ready: Boolean = false;
      /**
       * Constructor.
       * 
       * @param model <code>Battle</code> instance containing information about whole battle:
       * units, buildings and playback information. Can't be <code>null</code>
       * 
       * @param battleMap <code>BattleMap</code> component
       */
      public function BattleController(battle:Battle, battleMap:BattleMap)
      {
         ClassUtil.checkIfParamNotNull("battle", battle);
         
         _battle = battle;
         _battleMap = battleMap;
         _log = battle.log; 
         outcome = battle.outcome;
         
         _battleMap.toggleShowPause(true);
         
         if (battle != null && !battle.hasSpaceUnitsOnly)
         {
            folliagesTimer = new Timer(FOLLIAGE_SWING_DELAY * timeMultiplier);
            folliagesTimer.addEventListener(TimerEvent.TIMER, swingRandomFolliages);
            folliagesTimer.start();
         }
         
         _timer = AnimationTimer.forBattle;
         if (battle != null)
            ready = true;
         _timer.start();
         
         _battleMap.refreshUnits();
         _battleMap.addEventListener(BattleControllerEvent.TOGGLE_PAUSE, togglePauseBattle);
         _battleMap.addEventListener(BattleControllerEvent.CHANGE_SPEED, refreshFps);
         _battleMap.viewport.paddingHorizontal = 20;
         _battleMap.viewport.paddingVertical = 20;
         EventBroker.subscribe(KeyboardEvent.KEY_DOWN, minimizeSpeed);
      }
      
      private function minimizeSpeed(e: KeyboardEvent): void
      {
         if (e.ctrlKey && e.shiftKey && e.keyCode == Keyboard.CAPS_LOCK)
         {
            if (_battleMap != null)
            {
               _battleMap.dispatchEvent(new BattleControllerEvent(BattleControllerEvent.CHANGE_SPEED, 0.1));
            }
         }
      }
      
      
      public function cleanup() : void
      {
         if (_timer)
         {
            _timer.stop();
            _timer = null;
            AnimationTimer.forBattle.setDelayToDefault();
         }
         if (_battleMap)
         {
            _battleMap.cleanup();
            _battleMap = null;
         }
         if (_battle)
         {
            _battle = null;
         }
         if (folliagesTimer)
         {
            folliagesTimer.stop();
            folliagesTimer = null;
         }
         if (moveTimer)
         {
            moveTimer.stop();
            moveTimer = null;
         }
         for each (var bubble: DamageBubble in dmgBubbles)
         {
            if (bubble.moveTween != null)
            {
               bubble.moveTween.kill();
               bubble.moveTween = null;
            }
         }
         dmgBubbles.removeAll();
         fps = DEFAULT_FPS;
      }
      
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private function get timeMultiplier() : Number
      {
         return DEFAULT_FPS / fps;
      }
      
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      private var started: Boolean = false;
      
      public function play() : void
      {
         started = true;
         ready = false;
         moveTimer = new Timer(UNITS_MOVE_DELAY * timeMultiplier);
         moveTimer.addEventListener(TimerEvent.TIMER, moveRandomUnit);
         moveTimer.start();
         nextOrder();
      }
      
      
      /* ###################### */
      /* ### PLAYBACK LOGIC ### */
      /* ###################### */
      
      private function swingRandomFolliages(e: Event): void
      {
         if (_battle != null)
         {
            for (var i: int = 0; i<SWINGING_FOLLIAGES; i++)
            {
               var swingingFolliage: BFoliageComp = 
                  _battleMap.folliages[_battle.rand.integer(0, _battleMap.folliages.length - 1)];
               swingingFolliage.swing();
            }
         }
      }
      
      private function moveRandomUnit(e: Event): void
      {
         if (_battle != null && _battleMap != null && _battleMap.unitsHash.size > 0)
         {
            var movingUnit: BUnitComp = _battleMap.getRandomUnit();
            if ((movingUnit != null) 
               && ((movingUnit.currentAnimation == null) || (movingUnit.currentAnimation == 'still')) 
               && (movingUnit.moveTween == null) && (movingUnit.getLiving() != 0) && (movingUnit.visible == true))
            {
               moveUnit(movingUnit);
            }
         }
         else
         {
            moveTimer.stop();
         }
      }
      
      private function moveUnit(unit:BUnitComp) : void
      {
         if (unit.isReady)
         {
            if (!ended)
            {
               var moveSpeed: Number = BattleConfig.getUnitMoveSpeed(unit.getModel().type);
               var moveLength: int = unit.flippedHorizontally?
                  _battleMap.unitsMatrix.getFreeHorizontalCols(
                     new Point(0, unit.yGridPos), 
                     new Point(unit.xGridPos - 1, 
                        unit.yGridPos + unit.getHeightInCells(BattleMap.GRID_CELL_HEIGHT) - 1),1)
                  :
                  _battleMap.unitsMatrix.getFreeHorizontalCols(
                     new Point(unit.xGridPos + unit.getWidthInCells(BattleMap.GRID_CELL_WIDTH), 
                        unit.yGridPos), 
                     new Point(_battleMap.unitsMatrix.columnCount - 1,
                        unit.yGridPos + unit.getHeightInCells(BattleMap.GRID_CELL_HEIGHT)-1),0);
               moveLength = _battle.rand.integer(0, moveLength);
               
               if (moveLength != 0)
               {
                  var leftTop: Point = new Point(unit.xGridPos, unit.yGridPos)
                  var bottomRight: Point = 
                     new Point(unit.xGridPos + unit.getWidthInCells(BattleMap.GRID_CELL_WIDTH) - 1,
                        unit.yGridPos + unit.getHeightInCells(BattleMap.GRID_CELL_HEIGHT) - 1);
                  var moveTime: Number = (moveLength * BattleMap.GRID_CELL_WIDTH / moveSpeed) * timeMultiplier;
                  unit.playAnimationImmediately('move');
                  unit.moveTween = new TweenLite(unit, moveTime, {
                     "onComplete" : function (): void{
                        if (unit != null && unit.moveTween != null)
                        {
                           if (_battleMap != null)
                           {
                              if (unit.dead)
                              {
                                 throw new Error(unit.participantModel.type+' is dead and is requested to stop moveTween');
                              }
                              unit.stopAnimations(); 
                              unit.moveTween.kill();
                              unit.moveTween = null;
                              _battleMap.unitsMatrix.move(leftTop, bottomRight, (unit.flippedHorizontally?
                                 -1 * moveLength: moveLength));
                              unit.xGridPos = unit.flippedHorizontally?leftTop.x - moveLength:leftTop.x + moveLength; 
                           }
                        }
                     },
                     "x": (unit.flippedHorizontally?
                        unit.x - (moveLength * BattleMap.GRID_CELL_WIDTH):
                        unit.x + (moveLength * BattleMap.GRID_CELL_WIDTH)),
                     "y": unit.y,
                     "ease": Linear.easeNone
                  });
               }
               else
                  if (_battle.rand.boolean(EMOTION_CHANCE))
                     unit.playRandomEmotion(_battle.rand);
            }
            else
            {
               if (_battle.rand.boolean(EMOTION_CHANCE))
                  unit.playRandomEmotion(_battle.rand);
            }
         }
      }
      
      private var _currentOrder:int = 0;
      
      
      private function get hasMoreOrders() : Boolean
      {
         return _log.length > _currentOrder;
      }
      
      private var moveTimer: Timer = null;
      
      private var folliagesTimer: Timer = null;
      
      private var ended: Boolean = false;
      
      private function nextOrder() : void
      {
         if (hasMoreOrders)
         {
            var nextLogItem: Order = new Order(_log.getItemAt(_currentOrder) as Array);
            executeOrder(nextLogItem);
         }
         else
         {
            ended = true;
            started = false;
            _battleMap.showReplayButton();
            showEnd();
         }
      }
      
      private function showEnd(): void
      {
         _battleMap.battleOverLabel.visible = true;
         _battleMap.battleOverLabel.outcome = outcome;
         _battleMap.battleOverLabel.scaleIn();
      }
      
      private var currentTick: int = 0;
      
      private function executeOrder(order:Order): void
      {
         _currentOrder++;
         switch (order.type)
         {
            case OrderType.TICK:
               if (order.kind == TickOrderKind.START)
               {
                  currentTick++;
                  _battleMap.setTick(currentTick);
               }
               nextOrder();
               break;
            
            case OrderType.GROUP:
               executeGroup(order.group);
               break;
            default:
               throw new Error('unhandled order type: '+order.type);
         }
      }
      
      
      private var fireOrdersToExecute:int = 0;
      private var appearOrdersToExecute:int = 0;
      private function executeGroup(order:GroupOrder) : void
      {
         _battleMap.currentGroupOrder++;
         fireOrdersToExecute = 0;
         appearOrdersToExecute = 0;
         for each (var appearOrder: Object in order.appearOrders)
         {
            appearOrdersToExecute++;
            appear(appearOrder.transporter, appearOrder.unit);
         }
         for each (var fireOrder:FireOrder in order.fireOrders)
         {
            fireOrdersToExecute += fireOrder.fireParts.length;
            executeFire(fireOrder);
         }
      }
      
      private function appear(transporterId: int, unitId: int): void
      {
         var teleporting: BUnitComp = _battleMap.getUnitWithId(unitId);
         var transporter: BUnitComp = _battleMap.getUnitWithId(transporterId);
         teleporting.appear(unitId);
         //============= INCREASE OVERALL HP BARS ====================
         var hpEntry: BOverallHp;
         switch (teleporting.participantModel.playerStatus)
         {
            case Owner.PLAYER:
               hpEntry = _battleMap.overallHp.selfHp;
               break;
            case Owner.ALLY:
               hpEntry = _battleMap.overallHp.allyHp;
               break;
            case Owner.ENEMY:
               hpEntry = _battleMap.overallHp.enemyHp;
               break;
            case Owner.NAP:
               hpEntry = _battleMap.overallHp.napHp;
               break;
         }
         hpEntry.groundMax += teleporting.participantModel.hpMax;
         hpEntry.groundCurrent += teleporting.participantModel.hpActual;
         //===========================================================
         function reduceAppearOrderCount(e: AnimatedBitmapEvent = null): void
         {
            if (e != null)
            {
               transporter.removeEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, reduceAppearOrderCount);
               //kill unit after unloading?
               if (!transporter.attacking && transporter.shouldDie)
               {
                  transporter.addEventListener(
                     AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE,
                     removeAnimatedComponentHandler
                  );
                  
                  if (transporter.dead)
                  {
                     throw new Error(transporter.participantModel.type+' cant die, because it is already dying');
                  }
                  if ((transporter.currentAnimation != null && transporter.currentAnimation.indexOf('fire') != -1) ||
                     transporter.attacking)
                  {
                     throw new Error(transporter.participantModel.type+' cant die, because it is shooting');
                  }
                  transporter.dead = true;
                  transporter.playAnimationImmediately("death");
               }
            }
            appearOrdersToExecute--;
            if (appearOrdersToExecute == 0 && fireOrdersToExecute == 0)
            {
               nextOrder();
            }
         }
         //transporter group already unloading one unit? then dont play animation
         if (transporter.currentAnimation == 'unload')
         {
            reduceAppearOrderCount();
         }
         else
         {
            if (transporter.moveTween != null)
            {
               ocupyNewCells(transporter as BUnitComp);
            }
            transporter.playAnimationImmediately('unload');
            transporter.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, reduceAppearOrderCount);
         }
      }
      
      
      private function executeFire(order:FireOrder): void
      {
         if (_battleMap != null)
         {
            var attacker:BBattleParticipantComp =
               _battleMap.getParticipant(order.executorType, order.executorId);
            if (attacker.attacking)
            {
               attacker.addPendingAttack(order);
               return;
            }
            attacker.attacking = true;
            var attackerModel: IMBattleParticipant = _battleMap.getParticipantModel(order.executorType, order.executorId);
            var partIndex:int = 0;
            var activateNextGun:Function = function (event:AnimatedBitmapEvent = null) : void
            {
               if (_battleMap != null)
               {
                  // When last gun is activated remove event listener
                  if (partIndex == order.fireParts.length - 1)
                  {
                     function resetToDefaultFrame(e: AnimatedBitmapEvent): void
                     {
                        attacker.showDefaultFrame();
                        attacker.removeEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, resetToDefaultFrame);
                     }
                     attacker.removeEventListener
                        (AnimatedBitmapEvent.ANIMATION_COMPLETE, activateNextGun);
                     attacker.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, resetToDefaultFrame);
                  }
                  var damage: int = 0;
                  var firePart:FireOrderPart = order.fireParts[partIndex];
                  var target:BBattleParticipantComp = 
                     _battleMap.getParticipant(firePart.targetType, firePart.targetId);
                  var targetModel: IMBattleParticipant = 
                     _battleMap.getParticipantModel(firePart.targetType, firePart.targetId);
                  if (attackerModel == null)
                     throw new Error("attacker is null");
                  if (targetModel == null)
                     throw new Error("target is null");
                  if (!firePart.missed)
                  {
                     damage = Math.min(targetModel.hp, firePart.damage);
                     targetModel.hp -= firePart.damage;
                  }
                  if (((attacker.x > target.x) && (attacker.flippedHorizontally == false)) ||
                     ((attacker.x < target.x) && (attacker.flippedHorizontally == true)))
                     attacker.flipHorizontally();
                  activateGun(firePart.gunId, attacker, target, targetModel, partIndex == (order.fireParts.length - 1), damage);
                  partIndex++;
               }
               else
               {
                  attacker.removeEventListener
                     (AnimatedBitmapEvent.ANIMATION_COMPLETE, activateNextGun);
               }
            }
            if (attacker.currentAnimation != 'appear' && attacker.currentAnimation != 'unload')
            {
               attacker.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, activateNextGun);
               activateNextGun();
            }
            else
            {
               function startFire(e: AnimatedBitmapEvent): void
               {
                  attacker.removeEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, startFire);
                  attacker.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, activateNextGun);
                  activateNextGun();
               }
               attacker.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, startFire);
            }
         }
      }
      
      private function activateGun(gunId:int,
                                   attacker:BBattleParticipantComp,
                                   target:BBattleParticipantComp,
                                   targetModel: IMBattleParticipant,
                                   lastGun: Boolean,
                                   damage: int) : void
      {
         var gun:BGun = attacker.getGun(gunId);
         if (gun == null)
         {
            throw new Error (attacker.participantModel.type + ' has no gun with id '+ gunId);
         }
         if ((!(gun.shotDelay > 0)) && (gun.shots > 1))
         {
            throw new Error ("gun " + gun.type + " should have stright possitive shot delay, but had " + gun.shotDelay +
               ' it must fire ' + gun.shots + ' shots');
         }
         
         var shotDelayTimer:Timer = new Timer(gun.shots > 1?(gun.shotDelay * timeMultiplier):(1), 
            gun.shots - 1);
         
         function togglePauseShotDelayTimer(e: BattleControllerEvent): void
         {
            if (paused)
            {
               shotDelayTimer.stop();
            }
            else
            {
               shotDelayTimer.start();
            }
         }
         
         function changeShotDelayTimerSpeed(e: BattleControllerEvent): void
         {
            shotDelayTimer.delay = shotDelayTimer.delay * (oldFps/fps);
         }
         
         function dealAnimationComplete (e: AnimatedBitmapEvent = null): void
         {
            //Check if all projectiles have been fired
            if (shotDelayTimer.currentCount == shotDelayTimer.repeatCount)
            {
               if (lastGun)
               { 
                  var nextFireOrder: FireOrder = attacker.finishAttack();
                  if (nextFireOrder != null)
                  {
                     var nextFireOrderTimer: Timer = new Timer(GROUP_DELAY * timeMultiplier, 1);
                     
                     function togglePauseNextFire(e: BattleControllerEvent): void
                     {
                        if (paused)
                        {
                           nextFireOrderTimer.stop();
                        }
                        else
                        {
                           nextFireOrderTimer.start();
                        }
                     }
                     
                     
                     function changeNextFireDelayTimerSpeed(e: BattleControllerEvent): void
                     {
                        nextFireOrderTimer.delay = nextFireOrderTimer.delay * (oldFps/fps);
                     }
                     
                     var trigerNextAttacker: Function = function (e: TimerEvent): void
                     {
                        attacker.attacking = false;
                        battleSpeedControl.removeEventListener(BattleControllerEvent.TOGGLE_PAUSE, togglePauseNextFire);
                        battleSpeedControl.removeEventListener(BattleControllerEvent.CHANGE_SPEED, changeNextFireDelayTimerSpeed);
                        executeFire(nextFireOrder);
                     }
                     
                     nextFireOrderTimer.addEventListener(TimerEvent.TIMER, trigerNextAttacker);
                     nextFireOrderTimer.start();
                     
                     battleSpeedControl.addEventListener(BattleControllerEvent.TOGGLE_PAUSE, togglePauseNextFire);
                     battleSpeedControl.addEventListener(BattleControllerEvent.CHANGE_SPEED, changeNextFireDelayTimerSpeed);
                  }
                  else
                  {
                     attacker.attacking = false;
                  }
                  if (attacker.shouldDie && !attacker.hasPendingAttacks() && !attacker.attacking)
                  {
                     attacker.addEventListener(
                        AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE,
                        removeAnimatedComponentHandler
                     );
                     
                     if (attacker.dead)
                     {
                        throw new Error(attacker.participantModel.type+' cant die, because it is already dying');
                     }
                     if ((attacker.currentAnimation != null && attacker.currentAnimation.indexOf('fire') != -1) ||
                        attacker.attacking)
                     {
                        throw new Error(attacker.participantModel.type+' cant die, because it is shooting');
                     }
                     attacker.dead = true;
                     attacker.playAnimationImmediately("death");
                  }
                  attacker.removeEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE,
                     dealAnimationComplete);
               }
            }
         }
         
         var fireShot:Function = function(event:TimerEvent = null) : void
         {
            createProjectile(
               gunId, attacker, target, targetModel, 
               shotDelayTimer.currentCount == 0,
               shotDelayTimer.currentCount == shotDelayTimer.repeatCount,
               damage
            );
            if (shotDelayTimer.currentCount == 0)
            {
               if (attacker != null)
               {
                  if (attacker.isReady)
                  {
                     if (attacker.moveTween != null)
                        ocupyNewCells(attacker as BUnitComp);
                     if (lastGun)
                     {
                        attacker.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, 
                           dealAnimationComplete);
                     }
                     if (attacker.dead)
                        throw new Error(attacker.participantModel.type+
                           ' is playing death animation, but still needs to shoot');
                     
                     attacker.playAnimationImmediately("fireGun" + gunId);
                     if (gun.shots > 1)
                     {
                        shotDelayTimer.addEventListener(TimerEvent.TIMER, fireShot);
                        shotDelayTimer.start();
                        battleSpeedControl.addEventListener(BattleControllerEvent.TOGGLE_PAUSE, togglePauseShotDelayTimer);
                        battleSpeedControl.addEventListener(BattleControllerEvent.CHANGE_SPEED, changeShotDelayTimerSpeed);
                     }
                  }
                  else
                  {
                     throw new Error(attacker.participantModel.type+' was not ready, but was requested to shoot');
                  }
               }
               else
               {
                  throw new Error('attacker wasnt found to handle after animation');
               }
            }
            else if (shotDelayTimer.currentCount == shotDelayTimer.repeatCount)
            {
               battleSpeedControl.removeEventListener(BattleControllerEvent.TOGGLE_PAUSE, togglePauseShotDelayTimer);
               if (attacker.currentAnimation == null || attacker.currentAnimation.indexOf('fire') == -1)
               {
                  dealAnimationComplete();
               }
            }
         };  
         if (attacker.currentAnimation != 'appear' && attacker.currentAnimation != 'unload')
         {
            fireShot();
            gun.playFireSound();
         }
         else
         {
            function startFire(e: AnimatedBitmapEvent): void
            {
               attacker.removeEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, startFire);
               fireShot();
               gun.playFireSound();
            }
            attacker.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, startFire);
         }
      }
      
      private var battleSpeedControl: EventDispatcher = new EventDispatcher();
      
      private function ocupyNewCells(unit: BUnitComp): void
      {
         if (unit.dead)
         {
            throw new Error(unit.participantModel.type+' is dead and is requested to stop moveTween');
         }
         unit.stopAnimations(); 
         unit.moveTween.kill();
         unit.moveTween = null;
         _battleMap.unitsMatrix.free(new Point(unit.xGridPos, unit.yGridPos),
            new Point(unit.xGridPos + unit.getWidthInCells(BattleMap.GRID_CELL_WIDTH) - 1, 
               unit.yGridPos + unit.getHeightInCells(BattleMap.GRID_CELL_HEIGHT) - 1));
         unit.xGridPos = Math.floor((unit.x + unit.xOffset)/BattleMap.GRID_CELL_WIDTH);
         
         _battleMap.unitsMatrix.occupy(new Point(unit.xGridPos, unit.yGridPos),
            new Point(unit.xGridPos + unit.getWidthInCells(BattleMap.GRID_CELL_WIDTH) - 1, 
               unit.yGridPos + unit.getHeightInCells(BattleMap.GRID_CELL_HEIGHT) - 1));
      }
      
      
      private function createProjectile(gunId:int,
                                        attacker:BBattleParticipantComp,
                                        target:BBattleParticipantComp,
                                        targetModel: IMBattleParticipant,
                                        triggerTargetAnimation:Boolean,
                                        isLastProjectile:Boolean,
                                        damage: int) : void
      {
         if (_battleMap != null)
         {
            var gun:BGun = attacker.getGun(gunId);
            var pModel:BProjectile = new BProjectile();
            pModel.gunType = gun.type;
            
            /**
             * Now we have to apply transformations to the component and fix projectile departure and
             * arrival coordinates. This is a complex operation so handle with care!
             */
            var pointGun:Point    = attacker.getAbsoluteGunPosition(gunId);
            var dispersion: Number = MathUtil.randomBetween(-gun.dispersion, gun.dispersion);
            var pointTarget:Point = target.getAbsoluteTargetPoint();
            pointTarget.y += dispersion;
            // angle between a horizontal axis and the vector which starts at pointGun and ends at pointTarget
            // in degrees
            var direction:Vector3D =  new Vector3D(pointTarget.x, pointTarget.y)
               .subtract
               (new Vector3D(pointGun.x, pointGun.y)); 
            var angle:Number = MathUtil.radiansToDegrees(Vector3D.angleBetween(direction, NORM_X));
            angle = direction.y >= 0 ? angle : -angle;
            
            var pComponent:BProjectileComp = new BProjectileComp(pModel);
            var alf:AdvancedLayoutFeatures2D = new AdvancedLayoutFeatures2D();
            alf.transformAround2D(pModel.headCoords, null, angle, pointTarget);
            pointTarget = alf.computedMatrix.transformPoint(new Point());
            alf.transformAround2D(pModel.tailCoords, null, angle, pointGun);
            pComponent.transform.matrix = alf.computedMatrix;
            pComponent.depth =  _battleMap.unitsMatrix.rowCount;
            projectiles.addItem(pComponent);
            _battleMap.addElement(pComponent);
            
            
            //            // move, rotate and scale component to its end position to find out final x and y coordinates
            //            pComponent.transformAround2D(pModel.headCoords, null, angle, pointTarget);
            //            pointTarget.x = pComponent.x;
            //            pointTarget.y = pComponent.y;
            //            // now make all transformations to put projectile right on its starting position
            //            pComponent.transformAround2D(pModel.tailCoords, null, angle, pointGun);
            //            // set depth
            //            pComponent.depth = _battleMap.unitsMatrix.rowCount
            //            // add to display list and active particles list
            //            projectiles.addItem(pComponent);
            //            _battleMap.addElement(pComponent);
            
            // tween the particle
            var shootTime:Number = ((pointTarget.subtract(pointGun).length / pModel.speed) / 1000)
               * timeMultiplier;
            pComponent.moveTween = new TweenLite(pComponent, shootTime, {
               "onComplete" :  
               function (): void
               {
                  if (_battleMap != null)
                  {
                     getOnProjectileHitHandler(pComponent, target, targetModel, triggerTargetAnimation, isLastProjectile, damage);
                  }
                  pComponent.moveTween = null;
               },
               "x": pointTarget.x,
               "y": pointTarget.y,
               "ease": Linear.easeNone
            });
         }
      }
      
      private var dmgBubbles: ArrayCollection = new ArrayCollection();
      
      private function getOnProjectileHitHandler(projectile:BProjectileComp,
                                                 target:BBattleParticipantComp,
                                                 targetModel: IMBattleParticipant,
                                                 triggerTargetAnimation:Boolean,
                                                 isLastProjectile:Boolean,
                                                 damageTaken: int) : void
      {
         projectile.addEventListener(
            AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE,
            removeAnimatedComponentHandler
         );
         projectile.playAnimationImmediately("hit");
         
         if (triggerTargetAnimation)
         {
            targetModel.hpActual -= damageTaken;
            var dmgBubble: DamageBubble = new DamageBubble();
            dmgBubble.depth = _battleMap.unitsMatrix.rowCount + 10;
            dmgBubble.damage = damageTaken;
            dmgBubble.x = target.getAbsoluteTargetPoint().x - 20;
            dmgBubble.y = target.getAbsoluteTargetPoint().y - 20;
            _battleMap.addDamageBubble(dmgBubble);
            dmgBubbles.addItem(dmgBubble);
            dmgBubble.moveTween = new TweenLite(dmgBubble, DAMAGE_BUBBLE_DURATION * timeMultiplier, {
               "onComplete" :  
               function (): void
               {
                  dmgBubble.moveTween = null;
                  _battleMap.removeDamageBubble(dmgBubble);
                  dmgBubbles.removeItemAt(dmgBubbles.getItemIndex(dmgBubble));
               },
               'y': dmgBubble.y - 40,
               "alpha": 0.2});
            var hpEntry: BOverallHp;
            switch (targetModel.playerStatus)
            {
               case Owner.PLAYER:
                  hpEntry = _battleMap.overallHp.selfHp;
                  break;
               case Owner.ALLY:
                  hpEntry = _battleMap.overallHp.allyHp;
                  break;
               case Owner.ENEMY:
                  hpEntry = _battleMap.overallHp.enemyHp;
                  break;
               case Owner.NAP:
                  hpEntry = _battleMap.overallHp.napHp;
                  break;
            }
            if (targetModel.kind == UnitKind.GROUND)
            {
               hpEntry.groundCurrent -= damageTaken; 
            }
            else
            {
               hpEntry.spaceCurrent -= damageTaken;
            }
         }
         
         // Kills unit or plays hit animation only
         if (triggerTargetAnimation && target.isReady)
         {
            if (target.getLiving() == 0)
            {
               if (target.moveTween != null)
               {
                  ocupyNewCells(target as BUnitComp);
               }
               killParticipant(target, targetModel.id);
            }
            else
            {
               if (target.hasAnimation("hit") && !target.attacking)
               {
                  if (target.currentAnimation != null && target.currentAnimation.indexOf('fire') != -1)
                  {
                     throw new Error(target.participantModel.type+
                        ' cant play hit, because he is still shooting');
                  }
                  if (target.getLiving() == 0 || target.dead)
                  {
                     throw new Error(target.participantModel.type+
                        ' cant play hit, because he is dead');
                  }
                  target.playAnimationImmediately("hit");
                  if (target.moveTween != null)
                  {
                     ocupyNewCells(target as BUnitComp);
                  }
               }
            }
         }
         //TODO check this thing: units are not ready if screen is not focused 
         //(other tab visible or minimized)
         // Go for the next order if needed
         if (isLastProjectile)
         {
            fireOrdersToExecute--;
            if (fireOrdersToExecute < 0)
            {
               throw new Error('there was more fire orders than expected');
            }
            if (appearOrdersToExecute == 0 && fireOrdersToExecute == 0)
            {
                  nextOrder();
            }
         }
      }
      
      
      private function killParticipant(participant:BBattleParticipantComp, id: int) : void
      {
         if (participant.shouldDie)
         {
            //            throw new Error(participant.participantModel.type+
            //               ' is already waiting to die, but was killed again!');
         }
         if (!participant.dead)
         {
            if (!(participant is BUnitComp) || (participant as BUnitComp).getLiving() == 0)
            {
               // Don't play immediately if still shooting, because firing next gun depends on shooting
               // animations playing properly.
               if (!participant.attacking && participant.currentAnimation != 'unload')
               {
                  participant.addEventListener(
                     AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE,
                     removeAnimatedComponentHandler
                  );
                  
                  if (participant.dead)
                  {
                     throw new Error(participant.participantModel.type+' cant die, because it is already dying');
                  }
                  if (participant.attacking)
                  {
                     throw new Error(participant.participantModel.type+' cant die, because it is shooting');
                  }
                  participant.dead = true;
                  participant.playAnimationImmediately("death");
               }
               else
               {
                  participant.shouldDie = true;
               }
            }
            else
            {
               throw new Error('illegal kill requested for '+ participant.participantModel.type);
            }
         }
      }
      
      private var projectiles: ArrayCollection = new ArrayCollection();
      
      private function removeAnimatedComponentHandler(event:AnimatedBitmapEvent) : void
      {
         if (_battleMap != null)
         {
            var target: * = event.target;
            if (target is BBattleParticipantComp)
            {
               if (!(target as BBattleParticipantComp).dead)
               {
                  throw new Error((target as BBattleParticipantComp).participantModel.type+
                     ' is not yet dead, but was requested to remove');
               }
               if ((target as BBattleParticipantComp).getLiving() != 0)
                  throw new Error((target as BBattleParticipantComp).participantModel.type+
                     ' is still alive, and was requested to remove');
               if ((target as BBattleParticipantComp).attacking)
                  throw new Error((target as BBattleParticipantComp).participantModel.type+
                     ' is still shooting, and was requested to remove');
               if (target is BUnitComp)
               {
                  var sadFlank: BFlank = _battle.getFlankByUnitId(
                     ((target as BUnitComp).model as BUnit).id);
                  
                  if (!sadFlank.hasAliveUnits())
                  {
                     _battleMap.unitsMatrix.freeCell(sadFlank.cellsToFree.start, 0);
                     _battleMap.unitsMatrix.freeCell(sadFlank.cellsToFree.end, 0);
                  }
                  _battleMap.removeUnit(target as BUnitComp);
               }
               else
               {
                  _battleMap.removeBuilding(target as BBuildingComp);
               }
            }
            else
            {
               projectiles.removeItemAt(projectiles.getItemIndex(target));
               _battleMap.removeElement(target as IVisualElement);
               event.target.cleanup();
            }
            event.target.removeEventListener(
               AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE,
               removeAnimatedComponentHandler
            );
         }
         else
         {
            event.target.removeEventListener(
               AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE,
               removeAnimatedComponentHandler);
         }
      }
      
      /* ###################### */
      /* ### BATTLE CONTROL ### */
      /* ###################### */
      
      private var oldFps: int = fps;
      
      private function refreshFps(e: BattleControllerEvent): void
      {
         var speed: Number = e.speed;
         oldFps = fps;
         fps = DEFAULT_FPS * speed;
         if (fps != oldFps)
         {
            if (moveTimer != null)
            {
               moveTimer.delay = UNITS_MOVE_DELAY * timeMultiplier;
            }
            if (folliagesTimer != null)
            {
               folliagesTimer.delay = FOLLIAGE_SWING_DELAY * timeMultiplier;
            }
            for each (var unit: BUnitComp in _battleMap.unitsHash)
            {
               if (unit != null && unit.moveTween != null)
               {
                  unit.moveTween.duration = unit.moveTween.duration * oldFps/fps;
                  unit.moveTween.currentTime = unit.moveTween.currentTime * oldFps/fps;
               }
            }
            AnimationTimer.forBattle.delay = AnimationTimer.forBattle.delay * oldFps/fps;
            
            for each (var shot: BProjectileComp in projectiles)
            {
               if (shot.moveTween != null)
               {
                  shot.moveTween.duration = shot.moveTween.duration * oldFps/fps;
                  shot.moveTween.currentTime = shot.moveTween.currentTime * oldFps/fps;
               }
            }
            
            for each (var dmgBubble: DamageBubble in dmgBubbles)
            {
               dmgBubble.moveTween.duration = dmgBubble.moveTween.duration * oldFps/fps;
               dmgBubble.moveTween.currentTime = dmgBubble.moveTween.currentTime * oldFps/fps;
            }
            
            battleSpeedControl.dispatchEvent(new BattleControllerEvent(BattleControllerEvent.CHANGE_SPEED));
         }
      }
      
      private var paused: Boolean = false;
      
      private function togglePauseBattle(e: BattleControllerEvent): void
      {
         if (!started)
         {
            if (ended)
            {
               _battle.logHash.speed = fps/DEFAULT_FPS;
               showBattle(_battleId, _battle.logHash);
            }
            else
            {
               _battleMap.toggleShowPause(false);
               play();
            }
         }
         else
         {
            paused = !paused;
            _battleMap.toggleShowPause(paused);
            togglePauseUnits();
            togglePauseShots();
            togglePauseDmgBubbles();
            togglePauseSwinging();
         }
      }
      
      private function togglePauseUnits(): void
      {
         if (paused)
         {
            moveTimer.stop();
            AnimationTimer.forBattle.stop();
            for each (var unit: BUnitComp in _battleMap.unitsHash)
            {
               if (unit != null && unit.moveTween != null)
               {
                  unit.moveTween.pause();
               }
            }
         }
         else
         {
            moveTimer.start();
            AnimationTimer.forBattle.start();
            for each (unit in _battleMap.unitsHash)
            {
               if (unit != null && unit.moveTween != null)
               {
                  unit.moveTween.resume();
               }
            }
         }
      }
      
      private function togglePauseShots(): void
      {
         if (paused)
         {
            for each (var shot: BProjectileComp in projectiles)
            {
               if (shot.moveTween != null)
               {
                  shot.moveTween.pause();
               }
            }
         }
         else
         {
            for each (shot in projectiles)
            {
               if (shot.moveTween != null)
               {
                  shot.moveTween.resume();
               }
            }
         }
         battleSpeedControl.dispatchEvent(new BattleControllerEvent(BattleControllerEvent.TOGGLE_PAUSE));
      }
      
      private function togglePauseDmgBubbles(): void
      {
         if (paused)
         {
            for each (var dmgBubble: DamageBubble in dmgBubbles)
            {
               if (dmgBubble.moveTween != null)
               {
                  dmgBubble.moveTween.pause();
               }
            }
         }
         else
         {
            for each (dmgBubble in dmgBubbles)
            {
               if (dmgBubble.moveTween != null)
               {
                  dmgBubble.moveTween.resume();
               }
            }
         }
      }
      
      private function togglePauseSwinging(): void
      {
         if (folliagesTimer != null)
         {
            if (paused)
            {
               folliagesTimer.stop();
            }
            else
            {
               folliagesTimer.start();
            }
         }
      }
      
   }
}
import flash.geom.Point;
import flash.geom.Vector3D;

import models.battle.FireOrder;

import mx.core.AdvancedLayoutFeatures;


class OrderType
{
   public static const TICK:String = "tick";
   public static const GROUP:String = "group";
   public static const APPEAR:String = "appear";
   public static const FIRE:String = "fire";
}


class TickOrderKind
{
   public static const START:String = "start";
   public static const END:String = "end";
}


class Order
{
   /**
    * Typed order representation.
    * 
    * @param logItem a log item to use as data
    */
   public function Order(logItem:Array)
   {
      type = logItem[0];
      switch(type)
      {
         case OrderType.TICK:
            kind = logItem[1];
            break;
         
         case OrderType.GROUP:
            group = new GroupOrder(logItem[1]);
            break;
      }
   }
   
   
   /**
    * Type of the order.
    * 
    * <p>If this property is equal to <code>OrderType.TICK</code>, only <code>kind</code>
    * property makes sence. If it is equal to <code>OrderType.GROUP</code>, only <code>group</code>
    * should be used.</p>
    */
   public var type:String;
   
   /**
    * Only makes sense if <code>type == OrderType.TICK</code>
    */
   public var kind:String;
   
   /**
    * Only makes sense if <code>type == OrderType.GROUP</code>
    */
   public var group:GroupOrder;
}


class GroupOrder
{
   public function GroupOrder(orders:Array)
   {
      for each (var rawOrder:Array in orders)
      {
         if (rawOrder[0] == OrderType.FIRE)
         {
            this.fireOrders.push(new FireOrder(rawOrder));
         }
         else //APPEAR
         {
            this.appearOrders.push({transporter: rawOrder[1], unit: rawOrder[2].id});
         }
      }
   }
   
   public var appearOrders: Array = [];
   
   public var fireOrders:Array = [];
}


class AdvancedLayoutFeatures2D extends AdvancedLayoutFeatures
{
   /**
    * Makes a 3D vector out of a given point (2D vector).
    */
   private static function getVector3D(point:Point) : Vector3D
   {
      if (!point)
      {
         return null;
      }
      return new Vector3D(point.x, point.y);
   }
   
   
   /**
    * Makes 2D transformations around the given transformation point.
    * 
    * @see #transformAround()
    */
   public function transformAround2D(transformCenter:Point,
                                     scale:Point = null,
                                     rotation:Number = 0,
                                     translation:Point = null,
                                     postLayoutScale:Point = null,
                                     postlayoutRotation:Point = null,
                                     postLayoutTranslation:Point = null) : void
   {
      transformAround(
         getVector3D(transformCenter),
         getVector3D(scale),
         new Vector3D(0, 0, rotation),
         getVector3D(translation),
         getVector3D(postLayoutScale),
         getVector3D(postlayoutRotation),
         getVector3D(postLayoutTranslation)
      );
   }
}