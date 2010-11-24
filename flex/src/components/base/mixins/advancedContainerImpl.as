// Advanced container mixin: this container removes elements form display list when they are
// hidden


import mx.core.IVisualElement;
import mx.events.FlexEvent;


protected override function childrenCreated() : void
{
   super.childrenCreated();
   for (var idx:int = 0; idx < numElements; idx++)
   {
      var element:IVisualElement = getElementAt(idx);
      element.includeInLayout = element.visible;
      addElementEventHandlers(element);
   }
}


private function addElementEventHandlers(elem:IVisualElement) : void
{
   elem.addEventListener(FlexEvent.SHOW, element_visibilityChangeHandler);
   elem.addEventListener(FlexEvent.HIDE, element_visibilityChangeHandler);
}


private function removeElementEventHandlers(elem:IVisualElement) : void
{
   elem.removeEventListener(FlexEvent.SHOW, element_visibilityChangeHandler);
   elem.removeEventListener(FlexEvent.HIDE, element_visibilityChangeHandler);
}


private function element_visibilityChangeHandler(e:FlexEvent) : void
{
   var element:IVisualElement = IVisualElement(e.target);
   element.includeInLayout = element.visible;
}


public override function removeElementAt(index:int):IVisualElement
{
   var element:IVisualElement = super.removeElementAt(index);
   removeElementEventHandlers(element);
   return element;
}


public override function addElementAt(element:IVisualElement, index:int):IVisualElement
{
   element.includeInLayout = element.visible;
   addElementEventHandlers(element);
   return super.addElementAt(element, index);
}
