package utils.components
{
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.ToggleButton;
   
   import utils.Objects;
   import utils.components.events.ToggleButtonsGroupEvent;

   
   /**
    * Dispatched when a toggle button has been selected or deselected in this group.
    * If both is true, only one event is dispatched.
    * 
    * @eventType utils.components.ToggleButtonsGroup.SELECTION_CHANGE
    */
   [Event(name="selectionChange", type="utils.components.events.ToggleButtonsGroupEvent")]
   
   
   public class ToggleButtonsGroup extends EventDispatcher
   {
      private var _buttons:ArrayCollection = new ArrayCollection();
      private var _selectedButton:ToggleButton = null;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function cleanup() : void
      {
         deselectSelected();
         for each (var button:ToggleButton in _buttons)
         {
            removeButtonHandlers(button);
         }
         _buttons = null;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function registerButton(button:ToggleButton) : void
      {
         Objects.paramNotNull("button", button);
         if (_buttons.contains(button))
         {
            throw new ArgumentError(
               "ToggleButton with id '" + button.id + "' has already been " +
               "registered in this group"
            );
         }
         _buttons.addItem(button);
         addButtonHandlers(button);
      }
      
      
      private var _fDispatchSelectionChangeInDeselect:Boolean = false;
      public function deselectSelected() : void
      {
         if (_selectedButton)
         {
            _selectedButton.selected = false;
            if (_fDispatchSelectionChangeInDeselect)
            {
               dispatchSelectionChangeEvent(null, _selectedButton);
               _fDispatchSelectionChangeInDeselect = false;
            }
            _selectedButton = null;
         }
      }
      
      
      public function select(button:ToggleButton) : void
      {
         if (!_buttons.contains(button))
         {
            throw new ArgumentError(
               "Provided toggle button with name '" + button.name + "' + has not been registered"
            );
         }
         var oldSelection:ToggleButton = _selectedButton;
         var newSelection:ToggleButton = button;
         deselectSelected();
         _selectedButton = button;
         _selectedButton.selected = true;
         dispatchSelectionChangeEvent(newSelection, oldSelection);
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchSelectionChangeEvent(selectedButton:ToggleButton,
                                                    deselectedButton:ToggleButton) : void
      {
         if (hasEventListener(ToggleButtonsGroupEvent.SELECTION_CHANGE))
         {
            dispatchEvent(new ToggleButtonsGroupEvent(
               ToggleButtonsGroupEvent.SELECTION_CHANGE,
               selectedButton, deselectedButton
            ));
         }
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function addButtonHandlers(button:ToggleButton) : void
      {
         button.addEventListener(MouseEvent.CLICK, button_clickHandler);
      }
      
      
      private function removeButtonHandlers(button:ToggleButton) : void
      {
         button.removeEventListener(MouseEvent.CLICK, button_clickHandler);
      }
      
      
      private function button_clickHandler(event:MouseEvent) : void
      {
         select(event.target as ToggleButton);
      }
   }
}