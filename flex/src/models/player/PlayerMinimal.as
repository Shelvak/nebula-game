package models.player
{
   import models.BaseModel;
   
   
   public class PlayerMinimal extends BaseModel
   {
      public function PlayerMinimal()
      {
         super();
      }
      
      
      [Bindable]
      [Optional]
      public var name:String = "";
   }
}