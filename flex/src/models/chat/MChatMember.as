package models.chat
{
   import models.BaseModel;
   
   
   /**
    * Member of the chat (not using <code>PlayerMinimal</code> because binding is not needed here).
    * Not pooled.
    * 
    * @param id id of a chat member
    * @param name name of a chat member
    */
   public class MChatMember extends BaseModel
   {
      public function MChatMember(id:int = 0, name:String = null)
      {
         super();
         this.id = id;
         this.name = name;
      }
      
      
      /**
       * Name of the member (player actually).
       * 
       * @default null
       */
      public var name:String;
      
      
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