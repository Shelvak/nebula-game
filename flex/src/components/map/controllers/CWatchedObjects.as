package components.map.controllers
{
   import interfaces.ICleanable;

   import spark.components.List;


   public class CWatchedObjects extends List implements ICleanable
   {
      private var _model:WatchedObjects;
      public function set model(value:WatchedObjects): void {
         if (_model != value) {
            if (_model != null) {
               _model.cleanup();
            }
            itemRendererFunction = null;
            _model = value;
            if (_model != null) {
               itemRendererFunction = _model.itemRendererFunction;
            }
            dataProvider = value;
         }
      }
      public function get model(): WatchedObjects {
         return _model;
      }

      public function cleanup(): void {
         model = null;
      }

      protected override function itemSelected(index:int,
                                               selected:Boolean) : void {
         super.itemSelected(index, selected);
         if (selected && index >= 0) {
            var sectorSelected:Sector = Sector(dataProvider.getItemAt(index));
            if (_model != null) {
               _model.itemSelected(sectorSelected)
            }
            selectedIndex = -1;
         }
      }
   }
}
