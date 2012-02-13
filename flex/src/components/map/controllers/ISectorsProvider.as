package components.map.controllers
{
   import mx.core.IFactory;


   public interface ISectorsProvider
   {
      function sectorsCompareFunction(a: Sector,
                                      b: Sector,
                                      fields: Array = null): int;
      function getSpaceSectors(): Array;
      function includeSectorsWithShipsOf(owner: int): Boolean;
      function itemRendererFunction(sector: Sector): IFactory;
   }
}
