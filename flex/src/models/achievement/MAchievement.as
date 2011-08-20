package models.achievement
{
   import flash.display.BitmapData;
   
   import models.objectives.Objective;

   /**
    # "completed" => Boolean,
    # "type" => String (objective type),
    # "key" => String (objective key filter),
    # "level" => String (objective level filter),
    # "alliance" => Boolean (is this achievement alliance enabled?),
    # "npc" => Boolean (objective NPC filter),
    # "limit" => Fixnum | nil (objective limit filter),
    # "count => Fixnum (number of times objective has to be completed)
    */
   public class MAchievement extends Objective
   {
      public function MAchievement(_type: String)
      {
         super(_type);
      }
      
      [Bindable]
      public var completed: Boolean;
      
      public override function get objectiveText(): String
      {
         return super.objectiveText;
      }
      
      [Bindable (event="willNotChange")]
      public function get image(): BitmapData
      {
         return objectivePart.image;
      }
   }
}