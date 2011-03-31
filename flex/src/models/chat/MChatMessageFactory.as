package models.chat
{
   import utils.ClassUtil;
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
         return activateObject(new MChatMessage());
      }
      
      
      /**
       * Activates - sets all properties to their defaults - instance of <code>MChatMessage</code>.
       * 
       * @param obj an instance of <code>MChatMessage</code> to activate. <b>Not null</b>.
       */
      public override function activateObject(obj:Object) : void
      {
         ClassUtil.checkIfParamNotNull("obj", obj);
         with (MChatMessage(obj))
         {
            playerId = 0;
            playerName = null;
            message = null;
            channel = null;
            time = null;
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