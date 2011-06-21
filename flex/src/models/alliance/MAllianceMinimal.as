package models.alliance
{
   import models.BaseModel;
   
   [Bindable]
   public class MAllianceMinimal extends BaseModel
   {
      [Required]
      public var name: String;
   }
}