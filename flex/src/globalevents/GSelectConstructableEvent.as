package globalevents
{
	
	
	/**
	 * The SelectConstructableEvent class represents the event object passed to the event
	 * listener for building selection from constructable list event.  
	 */
	public class GSelectConstructableEvent extends GlobalEvent
	{
		/**
		 * selected building to construct type
		 **/
		public var buildingType:String;
		
		public static const BUILDING_SELECTED: String = "selectedBuildingChanged"; 
		
		/**
		 * @param building new selected building type
		 **/
		public function GSelectConstructableEvent(building: String)
		{
			buildingType = building;
			super(BUILDING_SELECTED);
		}
	}
}