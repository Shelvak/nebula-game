package controllers.battle
{
   import animation.AnimationTimer;
   import animation.events.AnimatedBitmapEvent;
   
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   
   import components.battle.BBattleParticipantComp;
   import components.battle.BFoliageComp;
   import components.battle.BProjectileComp;
   import components.battle.BUnitComp;
   import components.battle.BattleMap;
   
   import config.BattleConfig;
   
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   import models.IBattleParticipantModel;
   import models.Owner;
   import models.battle.BFlank;
   import models.battle.BGun;
   import models.battle.BOverallHp;
   import models.battle.BProjectile;
   import models.battle.BUnit;
   import models.battle.Battle;
   import models.battle.FireOrder;
   import models.battle.FireOrderPart;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   
   import utils.ClassUtil;
   
   
   public class BattleController
   {
      /**
       * Default speed of animation measured in fps.
       */
      public static const DEFAULT_FPS:int = 20;
      
      
      /**
       * Minimum speed of animation measured in fps.
       */
      public static const MIN_FPS:int = 1;
      
      /**
       * time delay betwean two grouped unitComps fire orders 
       */      
      private static const GROUP_DELAY: int = 500;
      
      
      /**
       * Maximum speed of animation measured in fps.
       */
      public static const MAX_FPS:int = 250;
      
      private static const SWINGING_FOLLIAGES: int = 5;
      
      private static const UNITS_MOVE_DELAY: int = 30;
      
      private static const FOLLIAGE_SWING_DELAY: int = 500;
      
      private static const EMOTION_CHANCE: Number = 0.3;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      private var _timer:AnimationTimer = null;
      private var _battle:Battle = null;
      private var _battleMap:BattleMap = null;
      private var _log:ArrayCollection = null;
      
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
         
         if (battle != null)
         {
            folliagesTimer = new Timer(FOLLIAGE_SWING_DELAY);
            folliagesTimer.addEventListener(TimerEvent.TIMER, swingRandomFolliages);
            folliagesTimer.start();
         }
         
         _timer = AnimationTimer.forBattle;
         recalculateTimerDelay();
         if (battle != null)
            ready = true;
         _timer.start();
         
         _battleMap.refreshUnits();
      }
      
      
      public function cleanup() : void
      {
         if (_timer)
         {
            _timer.stop();
            _timer = null;
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
      }
      
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _animationFps:int = DEFAULT_FPS;
      /**
       * Speed of animation (frames / s). Default value is <code>DEFAULT_SPEED</code> (25).
       */
      public function set animationFps(value:int) : void
      {
         if (value >= MIN_FPS && value <= MAX_FPS)
         {
            if (_animationFps != value)
            {
               _animationFps = value;
               recalculateTimerDelay();
            }
         }
         else
         {
            throw new ArgumentError("property can be set to any value from range [" +
               MIN_FPS + "; " + MAX_FPS + "] but was " + value);
         }
      }
      /**
       * @private
       */
      public function get animationFps() : int
      {
         return _animationFps;
      }
      
      
      private function get timeMultiplier() : Number
      {
         return DEFAULT_FPS / animationFps;
      }
      
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function play() : void
      {
         ready = false;
         moveTimer = new Timer(UNITS_MOVE_DELAY);
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
         if (_battle != null && _battleMap != null)
         {
            var movingUnit: BUnitComp = _battleMap.getRandomUnit();
            if ((movingUnit != null) 
               && ((movingUnit.currentAnimation == null) || (movingUnit.currentAnimation == 'still')) 
               && (movingUnit.moveTween == null) && (movingUnit.getLiving() != 0))
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
               var moveTime: Number = moveLength * BattleMap.GRID_CELL_WIDTH / moveSpeed;
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
      }
      
      private var _currentOrder:int = 0;
      
      
      private function get hasMoreOrders() : Boolean
      {
         return _log.length > _currentOrder;
      }
      
      private var moveTimer: Timer = null;
      
      private var folliagesTimer: Timer = null;
      
      private function nextOrder() : void
      {
         if (hasMoreOrders)
         {
            var nextLogItem: Order = new Order(_log.getItemAt(_currentOrder) as Array);
            executeOrder(nextLogItem);
         }
         else
         {
            moveTimer.stop();
         }
      }
      
      private function executeOrder(order:Order): void
      {
         _currentOrder++;
         switch (order.type)
         {
            case OrderType.TICK:
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
      private function executeGroup(order:GroupOrder) : void
      {
         fireOrdersToExecute = 0;
         for each (var fireOrder:FireOrder in order.fireOrders)
         {
            fireOrdersToExecute += fireOrder.fireParts.length;
            executeFire(fireOrder);
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
            var attackerModel: IBattleParticipantModel = _battleMap.getParticipantModel(order.executorType, order.executorId);
            var partIndex:int = 0;
            var activateNextGun:Function = function (event:AnimatedBitmapEvent = null) : void
            {
               // When last gun is activated remove event listener
               if (partIndex == order.fireParts.length - 1)
               {
                  attacker.removeEventListener
                     (AnimatedBitmapEvent.ANIMATION_COMPLETE, activateNextGun);
               }
               var damage: int = 0;
               var firePart:FireOrderPart = order.fireParts[partIndex];
               var target:BBattleParticipantComp = 
                  _battleMap.getParticipant(firePart.targetType, firePart.targetId);
               var targetModel: IBattleParticipantModel = 
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
            
            attacker.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, activateNextGun);
            activateNextGun();
         }
      }
      
      
      private function activateGun(gunId:int,
                                   attacker:BBattleParticipantComp,
                                   target:BBattleParticipantComp,
                                   targetModel: IBattleParticipantModel,
                                   lastGun: Boolean,
                                   damage: int) : void
      {
         var gun:BGun = attacker.getGun(gunId);
         if (gun == null)
         {
            throw new Error (attacker.participantModel.type + ' has no gun with id '+ gunId);
         }
         var shotDelayTimer:Timer = new Timer(gun.shotDelay * timeMultiplier, gun.shots - 1);
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
                  var dealAnimationComplete: Function = function (e: AnimatedBitmapEvent): void
                  {
                     if (shotDelayTimer.currentCount == shotDelayTimer.repeatCount && lastGun)
                     { 
                        var nextFireOrder: FireOrder = attacker.finishAttack();
                        if (nextFireOrder != null)
                        {
                           var trigerNextAttacker: Function = function (e: TimerEvent): void
                           {
                              attacker.attacking = false;
                              executeFire(nextFireOrder);
                           }
                           var nextFireOrderTimer: Timer = new Timer(GROUP_DELAY, 1);
                           nextFireOrderTimer.addEventListener(TimerEvent.TIMER, trigerNextAttacker);
                           nextFireOrderTimer.start();
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
                  if (attacker.isReady)
                  {
                     if (lastGun)
                     {
                        attacker.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, 
                           dealAnimationComplete);
                     }
                     if (attacker.moveTween != null)
                        ocupyNewCells(attacker as BUnitComp);
                     if (attacker.dead)
                        throw new Error(attacker.participantModel.type+
                           ' is playing death animation, but still needs to shoot');
                     
                     attacker.playAnimationImmediately("fireGun" + gunId);
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
         };
         if (shotDelayTimer.repeatCount != 0)
         {
            shotDelayTimer.addEventListener(TimerEvent.TIMER, fireShot);
            shotDelayTimer.start();
         }
         fireShot();
         gun.playFireSound();
      }
      
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
                                        targetModel: IBattleParticipantModel,
                                        triggerTargetAnimation:Boolean,
                                        isLastProjectile:Boolean,
                                        damage: int) : void
      {
         if (_battleMap != null)
         {
            var gun:BGun = attacker.getGun(gunId);
            // Create projectile model:
            // calculate starting and ending positions
            // set projectile type
            var model:BProjectile = new BProjectile();
            model.fromPosition = attacker.getAbsoluteGunPosition(gunId);
            model.toPosition = target.getAbsoluteTargetPoint();
            model.gunType = gun.type;
            
            var component:BProjectileComp = new BProjectileComp(model);
            /**
             * Now fix projectile departure and destination positions as transformations
             * have been applied
             */
            model.fromPosition.x = model.fromPosition.x - component.tailOffset.x;
            model.fromPosition.y = model.fromPosition.y - component.height / 2 - component.tailOffset.y
            model.toPosition.x = model.toPosition.x - component.width - component.headOffset.x;
            model.toPosition.y = model.toPosition.y - component.height / 2 - component.headOffset.y;
            
            component.x = model.fromPosition.x;
            component.y = model.fromPosition.y;
            _battleMap.addElement(component);
            
            component.depth = _battleMap.unitsMatrix.rowCount;
            
            var shootTime:Number = (model.pathLength / model.speed) / 1000 * timeMultiplier;
            TweenLite.to(component, shootTime, {
               "onComplete" :  
               function (): void
               {
                  if (_battleMap != null)
                  {
                     getOnProjectileHitHandler(component, target, targetModel, triggerTargetAnimation, isLastProjectile, damage);
                  }
               },
               "x": model.toPosition.x,
               "y": model.toPosition.y,
               "ease": Linear.easeNone
            });
         }
      }
      
      
      private function getOnProjectileHitHandler(projectile:BProjectileComp,
                                                 target:BBattleParticipantComp,
                                                 targetModel: IBattleParticipantModel,
                                                 triggerTargetAnimation:Boolean,
                                                 isLastProjectile:Boolean,
                                                 damageTaken: int) : void
      {
         projectile.addEventListener(
            AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE,
            removeAnimatedComponentHandler
         );
         projectile.playAnimation("hit");
         
         if (triggerTargetAnimation)
         {
            targetModel.actualHp -= damageTaken;
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
            if (fireOrdersToExecute == 0)
            {
               nextOrder();
            }
         }
      }
      
      
      private function killParticipant(participant:BBattleParticipantComp, id: int) : void
      {
         if (participant.shouldDie)
            throw new Error(participant.participantModel.type+
               ' is already waiting to die, but was killed again!');
         if (!participant.dead)
         {
            if (!(participant is BUnitComp) || (participant as BUnitComp).getLiving() == 0)
            {
               // Don't play immediately if still shooting, because firing next gun depends on shooting
               // animations playing properly.
               if (!participant.attacking)
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
      
      
      private function removeAnimatedComponentHandler(event:AnimatedBitmapEvent) : void
      {
         if (_battleMap != null)
         {
            var target: * = event.target;
            if (target is BUnitComp)
            {
               if (!(target as BUnitComp).dead)
               {
                  throw new Error((target as BUnitComp).participantModel.type+
                     ' is not yet dead, but was requested to remove');
               }
               if ((target as BUnitComp).getLiving() != 0)
                  throw new Error((target as BUnitComp).participantModel.type+
                     ' is still alive, and was requested to remove');
               if ((target as BUnitComp).attacking)
                  throw new Error((target as BUnitComp).participantModel.type+
                     ' is still shooting, and was requested to remove');
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
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      /**
       * Calculates delay of timer when animation speed in fps is given.
       */
      private function recalculateTimerDelay() : void
      {
         _timer.delay = Math.floor(1000 / _animationFps);
      }
   }
}
import models.battle.FireOrder;


class OrderType
{
   public static const TICK:String = "tick";
   public static const GROUP:String = "group";
   public static const APPEAR:String = "appear";
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
   public function GroupOrder(fireOrders:Array)
   {
      for each (var rawFire:Array in fireOrders)
      {
         this.fireOrders.push(new FireOrder(rawFire));
      }
   }
   
   
   public var fireOrders:Array = [];
}