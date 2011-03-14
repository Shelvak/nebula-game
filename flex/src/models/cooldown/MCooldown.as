package models.cooldown
{
   import com.adobe.errors.IllegalStateError;
   
   import flash.errors.IllegalOperationError;
   
   import models.BaseModel;
   import models.IMSelfUpdating;
   import models.IMStaticMapObject;
   import models.cooldown.events.MCooldownEvent;
   import models.location.LocationMinimal;
   
   import namespaces.change_flag;
   
   import utils.DateUtil;
   
   
   /**
    * Dispatched when <code>endsIn</code> property has changed.
    * 
    * @eventType models.cooldown.events.MCooldownEvent.ENDS_IN_CHANGE
    */
   [Event(name="endsInChange", type="models.cooldown.events.MCooldownEvent")]
   
   
   public class MCooldown extends BaseModel implements IMStaticMapObject, IMSelfUpdating
   {
      public function MCooldown()
      {
         super();
      }
      
      
      private var _endsAt:Date = null;
      [Bindable(event="willNotChange")]
      /**
       * Time when this cooldown ends. Never <code>null</code> once initialized. Default is <code>null</code>.
       * 
       * <p>Metadata:<br/>
       * [Binable(event="willNotChange")]
       * </p>
       */
      public function set endsAt(value:Date) : void
      {
         _endsAt = value;
      }
      /**
       * @private
       */
      public function get endsAt() : Date
      {
         return _endsAt;
      }
      
      change_flag var endsIn:Boolean = true;
      [Bindable(event="endsInChange")]
      /**
       * Number of seconds this cooldown will end in.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="endsInChange")]
       * </p>
       */
      public function get endsIn() : int
      {
         checkState_endsAt();
         return Math.max(0, (_endsAt.time - DateUtil.currentTime) / 1000);
      }
      
      
      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */
      
      
      public function update() : void
      {
         change_flag::endsIn = true;
         if (hasEventListener(MCooldownEvent.ENDS_IN_CHANGE))
         {
            dispatchEvent(new MCooldownEvent(MCooldownEvent.ENDS_IN_CHANGE));
         }
      }
      
      
      public function resetChangeFlags() : void
      {
         change_flag::endsIn = false;
      }
      
      
      /* ######################### */
      /* ### IMStaticMapObject ### */
      /* ######################### */
      
      
      private var _currentLocation:LocationMinimal;
      [Required(alias="location")]
      /**
       * Location of this cooldown in a space map.
       * 
       * <p>Metadata:</br>
       * [Required(alias="location")]
       * </p>
       */
      public function set currentLocation(value:LocationMinimal) : void
      {
         _currentLocation = value;
      }
      /**
       * @private
       */
      public function get currentLocation() : LocationMinimal
      {
         return _currentLocation;
      }
      
      
      public function get isNavigable() : Boolean
      {
         return false;
      }
      
      
      public function navigateTo() : void
      {
      }
      
      
      /* ######################## */
      /* ### STATE VALIDATION ### */
      /* ######################## */
      
      
      private function checkState_endsAt() : void
      {
         if (_endsAt == null)
         {
            throwIllegalStateError("[prop endsAt] is null.");
         }
      }
      
      
      private function checkState_currentLocation() : void
      {
         if (_currentLocation == null)
         {
            throwIllegalStateError("[prop currentLocation] is null.");
         }
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      
      public override function toString() : String
      {
         return "[class: " + CLASS + 
                ", id: " + id +
                ", currentLocation: " + currentLocation +
                ", endsAt: " + endsAt +
                "]";
      }
      
      
      public override function equals(o:Object) : Boolean
      {
         if (o == null || !(o is MCooldown))
         {
            return false;
         }
         var cooldown:MCooldown = MCooldown(o);
         
         cooldown.checkState_currentLocation();
         checkState_currentLocation();
         
         return currentLocation.equals(cooldown.currentLocation);
      }
   }
}