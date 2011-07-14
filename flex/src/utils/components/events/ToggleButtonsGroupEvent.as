package utils.components.events
{
   import flash.events.Event;
   
   import spark.components.ToggleButton;
   
   public class ToggleButtonsGroupEvent extends Event
   {
      /**
       * @eventType selectionChange
       * 
       * @see utils.components.ToggleButtonsGroup
       */
      public static const SELECTION_CHANGE:String = "selectionChange";
      
      
      /**
       * Constructor.
       * 
       * @param selectedButton a button which has been selected
       * @param deselectedButton a button which has been deselected
       */ 
      public function ToggleButtonsGroupEvent(type:String,
                                              selectedButton:ToggleButton,
                                              deselectedButton:ToggleButton,
                                              bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type, bubbles, cancelable);
         _selectedButton = selectedButton;
         _deselectedButton = deselectedButton;
      }
      
      
      private var _selectedButton:ToggleButton = null;
      /**
       * A toggle button which has been selected. If there was no such button - <code>null</code>.
       */
      public function get selectedButton() : ToggleButton
      {
         return _selectedButton;
      }
      
      
      private var _deselectedButton:ToggleButton = null;
      /**
       * A toggle button which has been deselected. If there was no such button - <code>null</code>.
       */
      public function get deselectedButton() : ToggleButton
      {
         return _deselectedButton;
      }
   }
}