package models.constructionqueueentry
{
   import controllers.objects.ObjectClass;
   
   import flash.events.Event;
   
   import models.BaseModel;
   
   import utils.ModelUtil;
   import utils.locale.Localizer;
   
   [Bindable]
   public class ConstructionQueueEntry extends BaseModel
   {
      public function ConstructionQueueEntry(type: String = null, amount: int = 1)
      {
         super();
         if (type != null)
         {
            constructableType = type;
            count = amount;
         }
      }
      private var _constructableType: String;
      [Required]
      public function set constructableType(value: String): void
      {
         _constructableType = value;
         if (hasEventListener("constructableTypeChanged"))
         {
            dispatchEvent(new Event("constructableTypeChanged"));
         }
      }
      
      public function get constructableType(): String
      {
         return _constructableType;
      }
      
      [Required]
      public var constructorId: int;
      
      [Required]
      public var position: int;
      
      [Required]
      public function set count(value: int): void
      {
         _count = value;
         countSelected = _count;
      }
      
      public function get count(): int
      {
         return _count;
      }
      
      public function get isUnit(): Boolean
      {
         return ModelUtil.getModelClass(constructableType, false) == ObjectClass.UNIT;
      }
      
      [Bindable (event='constructableTypeChanged')]
      public function get title(): String
      {
         var constName:String = ModelUtil.getModelSubclass(constructableType, false);
         if (constName == null)
         {
            constName = constructableType;
         } 
         return Localizer.string(isUnit?'Units':'Buildings',  constName + '.name');
      }
      
      private var _count: int;
      
      [Optional]
      public var params: Object;
      
      public var countSelected: int= 0;
      
      public var selected: Boolean = false;
   }
}