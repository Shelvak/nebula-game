package models.chat
{
   import utils.Objects;
   import utils.pool.BasePoolableObjectFactory;
   import utils.pool.IPoolableObjectFactory;
   
   
   /**
    * Implementation of <code>IPoolableObjectFactory</code> for managing instances of
    * <code>MChatMessage</code>.
    */
   public class MChatMessageFactory extends BasePoolableObjectFactory implements IPoolableObjectFactory
   {
      public function MChatMessageFactory()
      {
         super();
      }
      
      
      /**
       * Creates new instance of <code>MChatMessage</code>. Calls <code>activateObject()</code> before
       * returning the instance.
       * 
       * @return new activated instance of <code>MChatMessage</code>.
       */
      public override function makeObject() : Object
      {
         var newObject:Object = new MChatMessage();
         activateObject(newObject)
         return newObject;
      }
      
      
      /**
       * Activates - sets all properties to their defaults - instance of <code>MChatMessage</code>.
       * 
       * @param obj an instance of <code>MChatMessage</code> to activate. <b>Not null</b>.
       */
      public override function activateObject(obj:Object) : void
      {
         Objects.paramNotNull("obj", obj);
         with (MChatMessage(obj))
         {
            playerId = 0;
            playerName = null;
            message = null;
            channel = null;
            time = null;
            converter = null;
         }
      }
      
      
      /**
       * Passivates the given instance of <code>MChatMessage</code>: calls activateObject().
       * 
       * @param obj an instance of <code>MChatMessage</code> to passivate. <b>Not null</b>.
       */
      public override function passivateObject(obj:Object) : void
      {
         activateObject(obj);
      }
   }
}