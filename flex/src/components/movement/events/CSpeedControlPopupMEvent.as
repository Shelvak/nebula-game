package components.movement.events
{
   import flash.events.Event;
   
   
   public class CSpeedControlPopupMEvent extends Event
   {
      /**
       * Dispatched when <code>CSpeedControlPopupM.speedModifier</code> property changes.
       * 
       * @eventType speedModifierChange
       * 
       * @see components.movement.CSpeedControlPopupM#speedModifier
       */
      public static const SPEED_MODIFIER_CHANGE:String = "speedModifierChange";
      
      
      /**
       * Dispatched when <code>ModelLocator.player.creds</code> property changes and as a
       * result <code>CSpeedControlPopupM.playerHasEnoughCreds</code> also changes.
       * 
       * @eventType playerCredsChange
       * 
       * @see components.movement.CSpeedControlPopupM#playerHasEnoughCreds
       */
      public static const PLAYER_CREDS_CHANGE:String = "playerCredsChange";
      
      
      public function CSpeedControlPopupMEvent(type:String)
      {
         super(type);
      }
   }
}