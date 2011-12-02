package utils.remote.rmo
{
   import com.adobe.serialization.json.JSON;
   
   import models.BaseModel;
   
   import utils.PropertiesTransformer;
   import utils.remote.IResponder;
   
   
   /**  
    * This type of RMO is sent to the server by the client.
    * 
    * @copy RemoteMessageObject
    */ 
   public class ClientRMO extends RemoteMessageObject
   {
      /**
       * An instance of <code>IResponder</code> which is responsible for any
       * actions that must be taken when a response message corresponding to a
       * message sent by the client has been recieved.
       * 
       * @default null
       */ 
      public var responder:IResponder = null;
      
      
      /**
       * A model that is associated mostly with this RMO. Will be used
       * by <code>ResponseMessageTracker</code>.
       */      
      public var model:BaseModel = null;
      
      
      /**
       * Any additional parameters, objects, models or whatever you may need once
       * <code>responder.result()</code> or <code>responder.cancel()</code> is called.
       * Server won't received anything you put in here. 
       */
      public var additionalParams:Object = null;
      
      
      
      /**
       * Creates an instance of <code>ClientRMO</code>. Id property is generated
       * during construction of the instance.
       */
      public function ClientRMO(parameters:Object,
                                model:BaseModel = null,
                                additionalParams:Object = null,
                                responder:IResponder = null,
                                action:String = null)
      {
         this.action = action;
         this.parameters = parameters;
         this.responder = responder;
         this.model = model;
         this.additionalParams = additionalParams;
         id = RemoteMessageObject.generateId();
      }
    
      
      
      /**
       * Converts this instance of <code>ClientRMO</code> to a JSON string.
       * 
       * @return JSON string that represents this instance of <code>ClientRMO</code>.
       */
      public function toJSON() : String
      {
         var jsonObject:Object = {
            "id": id,
            "action": action,
            "params": PropertiesTransformer.objectToUnderscore(parameters)
         };
         return JSON.encode(jsonObject);
      }
   }
}