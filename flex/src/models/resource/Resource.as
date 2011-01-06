package models.resource
{
	import config.Config;
	
	import models.BaseModel;
	import models.ModelLocator;
	import models.resource.events.ResourcesEvent;
	
	import utils.StringUtil;
	
	[Bindable]
	public class Resource extends BaseModel
	{
		public var type: String = "";
		private var _currentStock: Number = 0;
		private var _maxStock: Number = 0;
		private var _rate: Number = 0;
		
		public static function getTimeToReachResources(currentMetal: Resource, currentEnergy: Resource, currentZetium: Resource,
													   destMetal: int, destEnergy: int, destZetium: int): int
		{
			if (currentMetal.currentStock  >= destMetal &&
				 currentEnergy.currentStock >= destEnergy &&
				 currentZetium.currentStock >= destZetium)
				return 0
			else if (((currentMetal.rate <= 0) && (currentMetal.currentStock < destMetal)) || 
				      ((currentEnergy.rate <= 0) && (currentEnergy.currentStock < destEnergy)) || 
				      ((currentZetium.rate <= 0) && (currentZetium.currentStock < destZetium)))
				return -1
			else
			{
				var tempMetalReach: int = currentMetal.currentStock >= destMetal?0:
					Math.ceil((destMetal - currentMetal.currentStock)/currentMetal.rate);
				var tempEnergyReach: int = currentEnergy.currentStock >= destEnergy?0:
					Math.ceil((destEnergy - currentEnergy.currentStock)/currentEnergy.rate);
				var tempZetiumReach: int = currentZetium.currentStock >= destZetium?0:
					Math.ceil((destZetium - currentZetium.currentStock)/currentZetium.rate);
				
				var tempMetalLose: int = currentMetal.rate >= 0?int.MAX_VALUE:
					-1*Math.ceil((currentMetal.currentStock - destMetal)/currentMetal.rate);
				var tempEnergyLose: int = currentEnergy.rate >= 0?int.MAX_VALUE:
					-1*Math.ceil((currentEnergy.currentStock - destEnergy)/currentEnergy.rate);
				var tempZetiumLose: int = currentZetium.rate >= 0?int.MAX_VALUE:
					-1*Math.ceil((currentZetium.currentStock - destZetium)/currentZetium.rate);
				
				if (Math.max(tempMetalReach, tempEnergyReach, tempZetiumReach) > 
					Math.min(tempMetalLose, tempEnergyLose, tempZetiumLose))
					return -1
				else
					return Math.max(tempMetalReach, tempEnergyReach, tempZetiumReach);
			}
		}
      
      public static function getResourceVolume(ammount: Number, resourceType: String): int
      {
         return Math.ceil(ammount / Config.getResourceVolume(resourceType));
      }
      
      public static function getResourcesForVolume(volume: int, resourceType: String): Number
      {
         return volume * Config.getResourceVolume(resourceType);
      }
      
      [Bindable (event="resourceStorageChanged")]
		public function get maxStock(): Number
		{
			return _maxStock * ModelLocator.getInstance().resourcesMods.getStorageMod(type);
		}
      
      [Bindable (event="resourceRateChanged")]
		public function get rate(): Number
		{
			return _rate * ModelLocator.getInstance().resourcesMods.getRateMod(type);
		}
		
		public function set maxStock(value: Number): void
		{
			_maxStock = value;
         dispatchStorageChangeEvent();
		}
		
		public function set rate(value: Number): void
		{
			_rate = value;
         dispatchRateChangeEvent();
		}
		
		
		public function Resource(name: String = ""):void{
			type = name;
		}
		
		public function set currentStock(value: Number): void
		{
			_currentStock = value;
			dispatchStockChangeEvent();
		}
		
		[Bindable (event="resourceAmmountChanged")]
		public function get currentStock(): Number
		{
			return _currentStock;
		}
		
		private function dispatchStockChangeEvent(): void
		{
         if (hasEventListener(ResourcesEvent.RESOURCES_CHANGED))
         {
			   dispatchEvent(new ResourcesEvent(ResourcesEvent.RESOURCES_CHANGED));
         }
		}
      
      private function dispatchStorageChangeEvent(): void
      {
         if (hasEventListener(ResourcesEvent.STORAGE_CHANGED))
         {
            dispatchEvent(new ResourcesEvent(ResourcesEvent.STORAGE_CHANGED));
         }
      }
      
      private function dispatchRateChangeEvent(): void
      {
         if (hasEventListener(ResourcesEvent.RATE_CHANGED))
         {
            dispatchEvent(new ResourcesEvent(ResourcesEvent.RATE_CHANGED));
         }
      }
      
      public function renewAllInfoDueToModsChange(): void
      {
         dispatchStockChangeEvent();
         dispatchStorageChangeEvent();
         dispatchRateChangeEvent();
      }
      
      
      public override function toString():String
      {
         return "[class: " + CLASS + ", type: " + type + ", rate: " + rate +
                ", currentStock: " + currentStock + ", maxStock: " + maxStock + "]";
      }
      
      
      public override function equals(o:Object):Boolean
      {
         if (!super.equals(o))
         {
            return false;
         }
         var resource:Resource = Resource(o);
         return type == resource.type &&
                rate == resource.rate &&
                currentStock == resource.currentStock &&
                maxStock == resource.maxStock;
      }
	}
}