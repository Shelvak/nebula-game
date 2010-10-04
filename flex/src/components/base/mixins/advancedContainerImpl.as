// Advanced container mixin: this container removes elements form display list when they are
// hidden


import mx.collections.ArrayCollection;
import mx.core.IVisualElement;
import mx.events.FlexEvent;

/**
 * A list of all - visible and invisible - elements. All elements should be displayed
 * in order they are in this list.  
 */      
private var elements:ArrayCollection = new ArrayCollection();

/**
 * Adds an element to the end of <code>elements</code> list.
 */      
private function pushElement(elem:IVisualElement) : void
{
   elements.addItem(elem);
}

/**
 * Returns an element after the given element. If the given element is the last
 * one returns <code>null</code>;
 * 
 * @throws Error if the given element can't be found in the <code>elements</code> list. 
 */      
private function getNextVisibleEelement(elem:IVisualElement) : IVisualElement
{
   var index:int = elements.getItemIndex(elem);
   if (index == -1)
   {
      throw new Error("Element could not be found in elements list.");
   }
   var nextElem:IVisualElement;
   for (var i:int = index + 1; i < elements.length; i++)
   {
      nextElem = elements.getItemAt(i) as IVisualElement;
      if (nextElem.visible)
      {
         return nextElem;
      }
   }
   return null;
}

/**
 * Adds an element to <code>elements</code> list before a given element.
 * If a <code>before</code> element can't be found, new element is not
 * added.
 */
private function addElementBefore(elem:IVisualElement, before:IVisualElement) : void
{
   var index:int = elements.getItemIndex(before);
   if (index != -1)
   {
      elements.addItemAt(elem, index);
   }
}

/**
 * Adds an element to <code>elements</code> list before a given element.
 * If a <code>before</code> element can't be found, new element is not
 * added.
 */
private function addElementAfter(elem:IVisualElement, after:IVisualElement) : void
{
   var index:int = elements.getItemIndex(after);
   if (index != -1)
   {
      index += 1;
      elements.addItemAt(elem, index);
   }
}

/**
 * Adds SHOW and HIDE handlers to a given element. 
 */      
private function addElementListeners(elem:IVisualElement) : void
{
   elem.addEventListener(FlexEvent.SHOW, element_showHandler);
   elem.addEventListener(FlexEvent.HIDE, element_hideHandler);
}

/**
 * Removes SHOW and HIDE handlers from a given element. 
 */      
private function removeElementListeners(elem:IVisualElement) : void
{
   elem.removeEventListener(FlexEvent.SHOW, element_showHandler);
   elem.removeEventListener(FlexEvent.HIDE, element_hideHandler);
}

/**
 * When an element becomes visible adds it to display list in the correct position.
 */      
private function element_showHandler(e:FlexEvent) : void
{
   var elem:IVisualElement = e.target as IVisualElement;
   var nextVisible:IVisualElement = getNextVisibleEelement(elem);
   if (nextVisible == null)
   {
      super.addElement(elem);
   }
   else
   {
      super.addElementAt(elem, getElementIndex(nextVisible));
   }
}

/**
 * When an element becomes invisible removes it form the display list.
 */      
private function element_hideHandler(e:FlexEvent) : void
{
   super.removeElement(e.target as IVisualElement);
}

/**
 * When component has been created adds all elements in the display list
 * to the <code>elements</code> list. Then removes all invisible elements
 * from the display list. 
 */      
private function advCont_creationCompleteHandler(e:FlexEvent) : void
{
   var elem:IVisualElement;
   
   // Register listeners and add all children to children list
   for (var i:int = 0; i < numElements; i++)
   {
      elem = getElementAt(i);
      pushElement(elem);
      addElementListeners(elem);
   }
   
   // Now remove invisible children from display list
   for each (elem in elements)
   {
      if (! elem.visible)
      {
         removeElement(elem);
      }
   }
}


/**
 * This is advanced stuff. Implement those when you have time. 
 */
//      override public function addElementAt(elem:IVisualElement, index:int) : IVisualElement
//      {
//         addElementListeners(elem);
//         children.addItemAt(elem, index);
//         if (elem.visible)
//         {
//            super.addElementAt(elem, index);
//         }
//         return elem;
//      }
//      
//      override public function removeElementAt(index:int) : IVisualElement
//      {
//         var elem:IVisualElement = children.removeItemAt(index) as IVisualElement;
//         removeElementListeners(elem);
//         if (elem.visible)
//         {
//            super.removeElementAt(super.getElementIndex(elem));
//         }
//         return elem;
//      }
//      
//      override public function removeAllElements() : void
//      {
//         for each (var elem:IVisualElement in children)
//         {
//            removeElementListeners(elem)
//         }
//         children = new ArrayCollection();
//         super.removeAllElements();
//      }
