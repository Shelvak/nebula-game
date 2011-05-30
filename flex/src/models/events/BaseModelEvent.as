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
       * @eventType pendingChange
       */
      public static const PENDING_CHANGE:String = "pendingChange";
      
      
      /**
       * Dispatched when <code>BaseModel.flag_destructionPendingSet</code> flag has been set.
       * 
       * @eventType flagDestructionPendingSet
       * 
       * @see BaseModel#flag_destructionPending
       */
      public static const FLAG_DESTRUCTION_PENDING_SET:String = "flagDestructionPendingSet";
      
      
      /**
       * Dispatched when <code>id</code> property of <code>BaseModel</code>
       * changes.
       * 
       * @eventType idChange
       */
      public static const ID_CHANGE:String = "idChange";
      
      
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