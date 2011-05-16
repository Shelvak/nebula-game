package utils.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   
   import spark.components.Application;
   
   import utils.Objects;

   /**
    * Holds static methods for working with Flex display list.
    */
   public class DisplayListUtil
   {
      /**
       * Lets you find out if the given display element is direct or indirect child of the given
       * container. This method traverses up through display list until it reaches top level
       * application container.
       *  
       * @param element either instance of <code>IVisualElement</code> or <code>DisplayObject</code>
       * to check
       * @param container a container which migh or might not be direct or indirect parent of
       * the <code>element</code>
       * 
       * @return <code>true</code> if given <code>element</code> is a child of given
       * <code>container</code> or <code>false</code> otherwise
       * 
       * @throws ArgumentError if:
       * <ul>
       *    <li><code>element</code> is <code>null</code> or <code>undefined</code></li>
       *    <li><code>element</code> is not an istance of <code>IVisualElement</code> or
       *        <code>DisplayObject</code></li>
       *    <li><code>container</code> is <code>null</code></li>
       * </ul>
       * 
       * @see #isInsideType()
       */
      public static function isInsideInstance(element:*, container:DisplayObjectContainer) : Boolean
      {
         checkElement(element);
         checkContainerInstance(container);
         if (element == container)
         {
            return false;
         }
         while (element.parent != null)
         {
            element = element.parent;
            if (element == container)
            {
               return true;
            }
            else if (element is Application)
            {
               return false;
            }
         }
         return false;
      }
      
      
      /**
       * Does the same as <code>isInsideInstance()</code> but instead of checking against specific
       * instance of given container this method only checks if given element has direct or indirect
       * parent of the given type.
       *  
       * @param element either instance of <code>IVisualElement</code> or <code>DisplayObject</code>
       * to check
       * @param containerClass a subclass of <code>DisplayObjectContainer</code> to check against;
       * validity of this parameter won't be checkt so please provide valid subclass of
       * <code>DisplayObjectContainer</code>
       * 
       * @return <code>true</code> if given <code>element</code> has a direct or indirect parent of
       * given <code>containerType</code> or <code>false</code> otherwise
       * 
       * @throws ArgumentError if:
       * <ul>
       *    <li><code>element</code> is <code>null</code> or <code>undefined</code></li>
       *    <li><code>element</code> is not an istance of <code>IVisualElement</code> or
       *        <code>DisplayObject</code></li>
       *    <li><code>containerType</code> is <code>null</code></li>
       * </ul>
       * 
       * @see #isInsideInstance()
       */      
      public static function isInsideType(element:*, containerType:Class) : Boolean
      {
         checkElement(element);
         checkContainerType(containerType);
         while (element.parent != null)
         {
            element = element.parent;
            if (element is containerType)
            {
               return true;
            }
            else if (element is Application)
            {
               return false;
            }
         }
         return false;
      }
      
      
      /**
       * Returns collection of all children in the given container.
       */
      public static function getChildren(container:DisplayObjectContainer) : ArrayCollection
      {
         var list:ArrayCollection = new ArrayCollection();
         for (var i:int = 0; i < container.numChildren; i++)
         {
            list.addItem(container.getChildAt(i));
         }
         return list;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private static function checkElement(element:*) : void
      {
         Objects.paramNotNull("element", element);
         if (element is IVisualElement || element is DisplayObject)
         {
            return;
         }
         throw new ArgumentError ("[param element] must be either an instace of " +
                                  "IVisualElement or DisplayObject");
      }
      
      
      private static function checkContainerInstance(container:DisplayObjectContainer) : void
      {
         Objects.paramNotNull("container", container);
      }
      
      
      private static function checkContainerType(containerType:Class) : void
      {
         Objects.paramNotNull("containerType", containerType);
      }
   }
}