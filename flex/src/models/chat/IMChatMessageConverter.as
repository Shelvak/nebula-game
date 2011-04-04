package models.chat
{
   import flashx.textLayout.elements.FlowElement;

   /**
    * Defines interface of classes that convert <code>MChatMessage</code> to
    * <code>FlowElement</code>.
    */
   public interface IMChatMessageConverter
   {
      /**
       * Converts given message to <code>FlowElement</code> which will be added to a channel
       * content.
       * 
       * @param message <code>MChatMessage</code> to convert. <b>Not null</b>.
       * 
       * @return <code>FlowElement</code> which is a visual representation of the given
       * <code>MChatMessage</code>.
       */
      function toFlowElement(message:MChatMessage) : FlowElement;
   }
}