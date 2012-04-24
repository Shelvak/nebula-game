package components.base.paging
{
   import mx.core.IVisualElement;


   public interface IPageComponentFactory
   {
      function getPageComponent(pageModel: IPageModel): IVisualElement;
   }
}
