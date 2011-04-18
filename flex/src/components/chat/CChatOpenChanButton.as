package components.chat
{
   import controllers.ui.NavigationController;
   
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   
   import models.chat.MChat;
   
   import spark.components.Button;
   
   import utils.locale.Localizer;
   
   
   /**
    * Button enters this state when there are unread messages in the corresponding channel.
    */
   [SkinState("newMessage")]
   
   
   /**
    * Only defines additional skin state "newMessage", abstract property <code>imageKeySpecificPart</code>
    * used by the skin. Subclasses must implement that property and may set or unset <code>newMessage</code>
    * property as needed to enter or leave <code>newMessage</code> skin state.
    */
   public class CChatOpenChanButton extends Button
   {
      protected function get NAV_CTRL() : NavigationController
      {
         return NavigationController.getInstance();
      }
      
      
      protected function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      public function CChatOpenChanButton()
      {
         super();
         addEventListener(MouseEvent.CLICK, this_clickHandler, false, 0, true);
         setStyle("skinClass", CChatOpenChanButtonSkin);
      }
      
      
      /**
       * All images of the three main chat channel buttons are named like this:
       * <code>btn_chan_&lt;channel&gt;_(up|over|down|disabled)</code>; so this property must return
       * <code>&lt;channel&gt;</code> part.
       */
      public function get imageKeySpecificPart() : String
      {
         throw new IllegalOperationError("This property is abstract");
      }
      
      
      private var _newMessage:Boolean = false;
      /**
       * When this is set to <code>true</code> button enters "newMessage" state. And when this property
       * is set back to <code>false</code> the button leaves "newMessage" state.
       */
      protected function set newMessage(value:Boolean) : void
      {
         if (_newMessage != value)
         {
            _newMessage = value;
            invalidateSkinState();
         }
      }
      /**
       * @private
       */
      protected function get newMessage() : Boolean
      {
         return _newMessage;
      }
      
      
      protected override function getCurrentSkinState() : String
      {
         var superState:String = super.getCurrentSkinState();
         if (superState == "up" && _newMessage)
         {
            // we can enter this state only if button is in the "up" state
            return "newMessage";
         }
         return superState;
      }
      
      
      /**
       * <code>MouseEvent.CLICK</code> event handler of this button. Method in
       * <code>CChatOpenChanButton</code> only opens the chat window.
       */
      protected function this_clickHandler(event:MouseEvent) : void
      {
         NAV_CTRL.showChat();
      }
      
      
      protected function getString(property:String) : String
      {
         return Localizer.string("Chat", property);
      }
   }
}