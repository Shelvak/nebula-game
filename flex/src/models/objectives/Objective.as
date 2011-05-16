package models.objectives
{
   import models.BaseModel;
   
   [Bindable]
   public class Objective extends BaseModel
   {
      public var key: String;
      
      public var count: int = 1;
      
      public var type: String;
      
      public var level: int = 0;
      
      public var alliance: Boolean;
      
      public var npc: Boolean;
      
      public var progressId: int;
      
      public var limit: int;
      
      public var scientists: int;
      
      public var outcome: int;

      
      public function Objective(_type: String)
      {
         super();
         type = _type;
         objectivePart = ObjectivePart.getObjectivePart(this)
      }
      
      public var objectivePart: ObjectivePart;
      
      [Bindable (event="statusChange")]
      public function get objectiveText(): String
      {
         return objectivePart.objectiveText;
      }
   }
}