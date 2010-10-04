package models.battle.events
{
   import flash.events.Event;
   
   public class ProjectileEvent extends Event
   {
      public static const PATH_COMPLETED: String = 'projectilePathCompleted';
      
      public var projectile:BProjectileComp;
      public var hitTarget:BBattleParticipantComp;
      public var targetModel: IBattleParticipantModel;
      public var triggerTargetAnimation:Boolean;
      public var isLastProjectile:Boolean;
      /**
       * 
       * @param type
       * case of PATH_COMPLETED
       *    projectile = params.projectile;
       *    hitTarget = params.target;
       *    targetModel = params.targetModel;
       *    triggerTargetAnimation = params.trigerTargetAnimation;
       *    isLastProjectile = params.isLastProjectile;
       * @param params
       * 
       */      
      public function ProjectileEvent(type:String, params: *)
      {
         if (type == PATH_COMPLETED)
         {
            projectile = params.projectile;
            hitTarget = params.target;
            targetModel = params.targetModel;
            triggerTargetAnimation = params.trigerTargetAnimation;
            isLastProjectile = params.isLastProjectile;
         }
         super(type, false, false);
      }
   }
}