package models.events
{
   import flash.events.Event;
   
   import models.BaseModel;
   
   
   public class BaseModelEvent extends Event
   {
      /**
       * Dispatched when <code>pending</code> property of <code>BaseModel</code>
       * changes.
       * 
       * @eventType modelPendingChange
       */
      public static const PENDING_CHANGE:String = "modelPendingChange";
      
      
      /**
       * @eventType flagDestructionPendingSet
       * 
       * @see BaseModel#flag_destructionPending
       */
      public static const FLAG_DESTRUCTION_PENDING_SET:String = "flagDestructionPendingSet";
      
      
      /**
       * Dispatched when <code>id</code> property of <code>BaseModel</code>
       * changes.
       * 
       * @eventType modelIdChange
       */
      public static const ID_CHANGE:String = "modelIdChange";
      
      
      /**
       * Typed alias for <code>target</code> property.
       */
      public function get model() : BaseModel
      {
         return target as BaseModel;
      }
      
      
      /**
       * Constructor.
       */
      public function BaseModelEvent(type:String)
      {
         super(type, false, false);
      }
   }
}