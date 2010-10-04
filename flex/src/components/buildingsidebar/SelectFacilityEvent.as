package components.buildingsidebar
{
	import flash.events.Event;
	
	import models.building.Building;
	
	/**
	 * The SelectFacilityEvent class represents the event object passed to the event
	 * listener for facility selection from building facilities list event.  
	 */
	public class SelectFacilityEvent extends flash.events.Event
	{
		/**
		 * selected facility to construct
		 **/
		public var facility:Building;
		
		public static const FACILITY_SELECTED_EVENT: String = "SelectedFacilityChanged"; 
		
		/**
		 * @param facilityObj new selected facility model
		 **/
		public function SelectFacilityEvent(facilityObj:Building)
		{
			super(FACILITY_SELECTED_EVENT);
			facility=facilityObj;
		}
	}
}