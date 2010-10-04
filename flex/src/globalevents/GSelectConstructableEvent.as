package globalevents
{
   import models.building.Building;
	
	
	/**
	 * The SelectConstructableEvent class represents the event object passed to the event
	 * listener for building selection from constructable list event.  
	 */
	public class GSelectConstructableEvent extends GlobalEvent
	{
		/**
		 * selected building to construct
		 **/
		public var building:Building;
		
		public static const BUILDING_SELECTED: String = "selectedBuildingChanged"; 
		
		/**
		 * @param building new selected building type
		 **/
		public function GSelectConstructableEvent(_building: Building)
		{
			building = _building;
			super(BUILDING_SELECTED);
		}
	}
}