package components.battle
{
   import animation.Sequence;
   import animation.events.AnimatedBitmapEvent;
   
   import com.greensock.TweenLite;
   
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.engine.FontWeight;
   
   import models.IAnimatedModel;
   import models.IBattleParticipantModel;
   import models.ModelsCollection;
   import models.battle.BGun;
   import models.battle.BUnit;
   import models.battle.FireOrder;
   import models.battle.events.ParticipantEvent;
   
   import mx.events.CollectionEvent;
   import mx.graphics.SolidColor;
   
   import spark.components.Group;
   import spark.components.Label;
   import spark.layouts.TileLayout;
   import spark.primitives.Rect;
   
   public class BBattleParticipantComp extends Group
   {
      private static const HP_ROW_HEIGHT: int = 3;
      private static const MIN_BAR_WIDTH: int = 25;
      /**
       * Constructor.
       */ 
      public function BBattleParticipantComp(model:IBattleParticipantModel)
      {
         super();
         _animatedBitmap = new BAnimatedBitmap(model);
         initFrames();
         initAnimations();
         
         group.addEventListener(CollectionEvent.COLLECTION_CHANGE, refresh);
         if (model is BUnit && (model as BUnit).appearOrder > 0)
         {
            appearGroup.addItem(model);
         }
         else
         {
            group.addItem(model);
         }
      }
      
      /**
       * unit is hidden due to not enough place in flank.
       * this property is set to true if right now map is in initialization phaze
       * and this unit was not able to fit in flank bounds. 
       */      
      public var hidden: Boolean;
      
      
      protected function initFrames() : void
      {
         _animatedBitmap.setFrames(model.framesData);
      }
      
      
      protected function initAnimations() : void
      {
      }
      
      public function addParticipant(modelToAdd: IBattleParticipantModel): void
      {
         if (modelToAdd is BUnit && (modelToAdd as BUnit).appearOrder > 0)
         {
            appearGroup.addItem(modelToAdd);
         }
         else
         {
            group.addItem(modelToAdd);
         }
      }
      
      
      public function cleanup() : void
      {
         removeAnimatedBitmapEventHandlers(_animatedBitmap);
         _animatedBitmap.cleanup();
      }
      
      public override function toString() : String
      {
         return "<BBattleParticipantComp model=" + participantModel.toString() + ">";
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public function get participantModel() : IBattleParticipantModel
      {
         return _animatedBitmap.model as IBattleParticipantModel;
      }
      
      /**
       * marks if this unit has been killed during his attack order
       * and should play death animation after he ends firing guns
       */      
      public var shouldDie: Boolean = false;
      
      public var dead: Boolean = false;
      
      private var _count: int = 0;
      
      private var _maxCount: int = 0;
      
      public var attacking: Boolean = false;
      
      private var attackOrdersList: Array = [];
      
      public function finishAttack(): FireOrder
      {
         if (attackOrdersList.length > 0)
            return attackOrdersList.pop();
         return null;
      }
      
      public function hasPendingAttacks(): Boolean
      {
         return attackOrdersList.length != 0;
      }
      
      public function addPendingAttack(attackOrder: FireOrder): void
      {
         attackOrdersList.push(attackOrder);
      }
      
      public function get model() : IAnimatedModel
      {
         return _animatedBitmap.model;
      }
      
      public function set count(value: int): void
      {
         _count = value;
         countLabel.text = _count + '/' + _maxCount;
         countLabel.visible = _count > 0 && _maxCount > 1;
      }
      
      public function set maxCount(value: int): void
      {
         _maxCount = value;
         countLabel.text = _count + '/' + _maxCount;
         countLabel.visible = _count > 0 && _maxCount > 1;
      }
      
      
      public function set source(value:BitmapData) : void
      {
         _animatedBitmap.source = value;
      }
      public function get source() : BitmapData
      {
         return _animatedBitmap.source as BitmapData;
      }
      
      
      public function get currentAnimation() : String
      {
         return _animatedBitmap.currentAnimation;
      }
      
      
      public function get flippedHorizontally() : Boolean
      {
         return _animatedBitmap.flippedHorizontally;
      }
      
      
      public function get isReady() : Boolean
      {
         return _animatedBitmap.isReady;
      }
      
      public function get isDead() : Boolean
      {
         return currentAnimation == "death";
      }
      
      /* ################ */
      /* ### CHILDREN ### */
      /* ################ */
      
      private var testEnabled: Boolean = false;
      
      private var _animatedBitmap:BAnimatedBitmap;
      
      private var countLabel: Label = new Label();
      
      protected override function createChildren():void
      {
         super.createChildren();
         _animatedBitmap.verticalCenter = 0;
         _animatedBitmap.horizontalCenter = 0;
         addAnimatedBitmapEventHandlers(_animatedBitmap);
         addElement(_animatedBitmap);
         
         countLabel.horizontalCenter = relativeBox.width/2 - 15;
         countLabel.y = relativeBox.y + 10;
         countLabel.setStyle('fontWeight', FontWeight.BOLD);
         addElement(countLabel);
         
         var _layout: TileLayout = new TileLayout();
         _layout.requestedRowCount = HP_ROW_HEIGHT;
         _layout.verticalGap = 1;
         _layout.horizontalGap = 1;
         hpGroup.layout = _layout;
         addElement(hpGroup);
         
         
         if (testEnabled)
         {
            borderTest = new Rect();
            var rBox: Rectangle = relativeBox;
            borderTest.x = rBox.x;
            borderTest.width = rBox.width;
            borderTest.y = rBox.y;
            borderTest.height = rBox.height;
            borderTest.fill = new SolidColor(0xff0000, 1);
            borderTest.alpha = 0.7;
            addElement(borderTest);
         }
      }
      
      private var borderTest: Rect = new Rect();
      
      protected override function measure():void
      {
         if (_animatedBitmap)
         {
            measuredMinWidth = _animatedBitmap.width;
            measuredMinHeight = _animatedBitmap.height;
            measuredWidth = _animatedBitmap.width;
            measuredHeight = _animatedBitmap.height + 5;
         }
      }
      
      protected override function commitProperties():void
      {
         super.commitProperties();
         if (hpFlag)
         {
            refresh();
         }
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function playAnimation(name:String) : void
      {
         try
         {
            _animatedBitmap.playAnimation(name);
         }
         catch(err: ArgumentError)
         {
            throw new ArgumentError(participantModel.type + ': ' + err);
         }
      }
      
      
      public function playAnimationImmediately(name:String) : void
      {
         try
         {
            _animatedBitmap.playAnimationImmediately(name);
         }
         catch(err: ArgumentError)
         {
            throw new ArgumentError(participantModel.type + ': ' + err);
         }
      }
      
      
      public function stopAnimations() : void
      {
         _animatedBitmap.stopAnimations();
      }
      
      
      public function addAnimation(name:String, sequence:Sequence) : void
      {
         _animatedBitmap.addAnimation(name, sequence);
      }
      
      
      public function hasAnimation(name:String) : Boolean
      {
         return _animatedBitmap.hasAnimation(name);
      }
      
      
      public function getGun(id:int) : BGun
      {
         return participantModel.getGun(id);
      }
      
      public var moveTween: TweenLite = null;
      
      
      /**
       * @return a <code>Point</code> defining position of a gun with given id. Coordinates
       * are absolute: that is they are relative to location of parent container. 
       */
      public function getAbsoluteGunPosition(id:int) : Point
      {
         return thisTM.transformPoint(bmpTM.transformPoint(getGun(id).position));
      }
      
      public function flipHorizontally():void
      {
         _animatedBitmap.flipHorizontally();
      }
      
      private function addHpEventListeners(): void
      {
         for each (var participant: IBattleParticipantModel in group)
         {
            participant.addEventListener(ParticipantEvent.HP_CHANGE, flagHp);
         }
      }
      
      private var hpGroup: Group = new Group();
      private var hpList: Array = [];
      
      public var appearGroup: ModelsCollection = new ModelsCollection(); 
      public var group: ModelsCollection = new ModelsCollection(); 
      
      public function get groupLength(): int
      {
         return group.length;
      }    
      
      public function get totalGroupLength(): int
      {
         return group.length + appearGroup.length;
      }
      
      public function getGroupedParticipantModel(participantId: int) : IBattleParticipantModel
      {
         for each (var participant: IBattleParticipantModel in group)
         {
            if (participant.id == participantId)
               return participant;
         }
         for each (participant in appearGroup)
         {
            if (participant.id == participantId)
               return participant;
         }
         return null;
      }
      
      public var xGridPos: int;
      public var yGridPos: int;
      
      public function refresh(e: Event = null): void
      {
         barsCreated = true;
         count = getLiving();
         maxCount = groupLength;
         addHpEventListeners();
         addHpBars();
      }
      
      private var hpFlag: Boolean = false;
      private var barsCreated: Boolean = false;
      
      public function flagHp(e: Event = null): void
      {
         if (barsCreated)
         {
            hpFlag = true;
            invalidateProperties();
         }
      }
      
      private function getBarById(modelId: int): HpBar
      {
         for each (var hpBar: HpBar in hpList)
         {
            if (modelId == hpBar.modelId)
               return hpBar;
         }
         return null;
      }
      
      private function rebuildBars(): void
      {
         hpGroup.removeAllElements();
         hpList = [];
         var rBox: Rectangle = relativeBox;
         var barWidth: Number = rBox.width/Math.ceil(group.length/HP_ROW_HEIGHT);
         
         for each (var participant: IBattleParticipantModel in group)
         {
            var participantHpBar: HpBar = new HpBar();
            participantHpBar.width = barWidth;
            participantHpBar.modelId = participant.id;
            participantHpBar.currentStock = participant.actualHp;
            participantHpBar.maxStock = participant.maxHp;
            participantHpBar.playerStatus = participant.playerStatus;
            hpGroup.addElement(participantHpBar);
            hpList.push(participantHpBar);
            hpGroup.x = rBox.x;
            hpGroup.width = rBox.width;
            hpGroup.y = rBox.y - Math.min(groupLength, HP_ROW_HEIGHT) * 6;
         }
         if (getLiving() == 0)
         {
            hpGroup.visible = false;
         }
         else
         {
            hpGroup.visible = true;
         }
      }
      
      private function addHpBars(): void
      {
         var rBox: Rectangle = relativeBox;
         
         var barWidth: Number = rBox.width/Math.ceil(group.length/HP_ROW_HEIGHT);
         if (barWidth >= MIN_BAR_WIDTH)
         {
            for each (var participant: IBattleParticipantModel in group)
            {
               var participantBar: HpBar = getBarById(participant.id);
               if (participantBar == null)
               {
                  rebuildBars();
                  return;
               }
               else
               {
                  participantBar.currentStock = participant.actualHp;
               }
            }
            if (getLiving() == 0)
            {
               hpGroup.visible = false;
            }
            else
            {
               hpGroup.visible = true;
            }
         }
         else
         {
            hpGroup.removeAllElements();
            hpList = [];
            var totalMax: int = 0;
            var totalActual: int = 0;
            for each (participant in group)
            {
               totalMax += participant.maxHp;
               totalActual += participant.actualHp;
            }
            var participantsHpBar: HpBar = new HpBar();
            participantsHpBar.maxStock = totalMax;
            participantsHpBar.currentStock = totalActual;
            if (totalActual <= 0)
            {
               hpGroup.visible = false;
            }
            else
            {
               hpGroup.visible = true;
            }
            participantsHpBar.width = rBox.width
            participantsHpBar.playerStatus = participantModel.playerStatus;
            hpGroup.addElement(participantsHpBar);
            hpList.push(participantsHpBar);
            hpGroup.width = rBox.width;
         }
         
         hpGroup.x = rBox.x;
         hpGroup.y = rBox.y - Math.min(groupLength, HP_ROW_HEIGHT) * 6;
      }
      
      
      public function getLiving(): int
      {
         var count: int = 0;
         for each (var participant: IBattleParticipantModel in group)
         {
            if (participant.actualHp > 0)
               count++;
         }
         return count;
      }
      
      
      public function getWidthInCells(cellWidth: Number): int
      {
         return Math.ceil(boxWidth / cellWidth);
      }
      
      public function getHeightInCells(cellHeight: Number): int
      {
         return Math.ceil(boxHeight / cellHeight);
      }
      
      public function get xOffset():Number
      {
         return relativeBox.x;
      }
      
      public function get yOffset():Number
      {
         return relativeBox.y;
      }
      
      public function get boxWidth():Number
      {
         return relativeBox.width;
      }
      
      public function get boxHeight():Number
      {
         return relativeBox.height;
      }
      
      /**
       * @return a <code>Rectangle</code> defining a box of battle participant. Coordinates
       * are absolute: that is they are relative to location of parent container. 
       */
      public function getAbsoluteBox() : Rectangle
      {
         var box:Rectangle = participantModel.box;
         var tTopLeft:Point = thisTM.transformPoint(bmpTM.transformPoint(box.topLeft));
         var tBottomRight:Point = thisTM.transformPoint(bmpTM.transformPoint(box.bottomRight));
         var tBox:Rectangle = new Rectangle(
            tTopLeft.x < tBottomRight.x ? tTopLeft.x : tBottomRight.x,
            tTopLeft.y < tBottomRight.y ? tTopLeft.y : tBottomRight.y,
            box.width, box.height
         );
         return tBox;
      }
      
      public function get relativeBox() : Rectangle
      {
         var box:Rectangle = getAbsoluteBox();
         return new Rectangle(box.x - x, box.y - y, box.width, box.height);
      }
      
      
      /**
       * @return a targeting <code>Point</code> of this battle participant. Coordinates
       * are absolute: that is they are relative to location of parent container.
       */
      public function getAbsoluteTargetPoint() : Point
      {
         return thisTM.transformPoint(bmpTM.transformPoint(participantModel.targetPoint));
      }
      
      public function showDefaultFrame(): void
      {
         _animatedBitmap.showDefaultFrame();
      }
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get bmpTM() : Matrix
      {
         return _animatedBitmap.transform.matrix;
      }
      
      
      private function get thisTM() : Matrix
      {
         return transform.matrix;
      }
      
      
      public function dispatchAnimationCompleteEvent() : void
      {
         dispatchEvent(new AnimatedBitmapEvent(AnimatedBitmapEvent.ANIMATION_COMPLETE));
      }
      
      
      public function dispatchAllAnimationsCompleteEvent() : void
      {
         dispatchEvent(new AnimatedBitmapEvent(AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE));
      }
      
      
      private function addAnimatedBitmapEventHandlers(bitmap:BAnimatedBitmap) : void
      {
         bitmap.addEventListener(AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE, animatedBitmap_allAnimationsCompleteHandler);
         bitmap.addEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, animatedBitmap_animationCompleteHandler);
      }
      
      
      private function removeAnimatedBitmapEventHandlers(bitmap:BAnimatedBitmap) : void
      {
         bitmap.removeEventListener(AnimatedBitmapEvent.ALL_ANIMATIONS_COMPLETE, animatedBitmap_allAnimationsCompleteHandler);
         bitmap.removeEventListener(AnimatedBitmapEvent.ANIMATION_COMPLETE, animatedBitmap_animationCompleteHandler);
      }
      
      
      private function animatedBitmap_animationCompleteHandler(event:AnimatedBitmapEvent) : void
      {
         dispatchAnimationCompleteEvent();
      }
      
      
      private function animatedBitmap_allAnimationsCompleteHandler(event:AnimatedBitmapEvent) : void
      {
         dispatchAllAnimationsCompleteEvent();
      }
   }
}