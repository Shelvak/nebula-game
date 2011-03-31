package models.chat
{
   import models.BaseModel;
   
   
   /**
    * Member of the chat (not using <code>PlayerMinimal</code> because binding is not needed here).
    * Not pooled.
    */
   public class MChatMember extends BaseModel
   {
      public function MChatMember()
      {
         super();
      }
      
      
      /**
       * Name of the member (player actually).
       * 
       * @default null
       */
      public var name:String = null;
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      
      public override function toString() : String
      {
         return "[class: " + className +
                ", id: " + id +
                ", name: " + name + "]";
      }
   }
}