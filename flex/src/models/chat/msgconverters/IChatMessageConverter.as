package models.chat.msgconverters
{
   import flashx.textLayout.elements.FlowElement;
   import models.chat.MChatMessage;

   /**
    * Defines interface of classes that convert <code>MChatMessage</code> to
    * <code>FlowElement</code>.
    */
   public interface IChatMessageConverter
   {
      /**
       * Converts given message to <code>FlowElement</code> which will be added to a channel
       * content.
       * 
       * @param message <code>MChatMessage</code> to convert. <b>Not null</b>.
       * @param onPlayerElementClick if not <code>null</code> and if
       * implementation of this method creates a clickable player element, the
       * callback will be invoked whenever user clicks on this element. Callback
       * will be passed the id and name of the player clicked.
       * 
       * @return <code>FlowElement</code> which is a visual representation of the given
       * <code>MChatMessage</code>.
       */
      function toFlowElement(message: MChatMessage,
                             onPlayerElementClick: Function = null): FlowElement;
   }
}