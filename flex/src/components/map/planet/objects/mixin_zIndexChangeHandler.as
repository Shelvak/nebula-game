import models.planet.PlanetObject;
import models.planet.events.PlanetObjectEvent;

private function addModelZIndexChangeHandler(model:PlanetObject) : void
{
   model.addEventListener(PlanetObjectEvent.ZINDEX_CHANGE, model_zIndexChangeHandler);
}

private function removeModelZIndexChangeHandler(model:PlanetObject) : void
{
   model.removeEventListener(PlanetObjectEvent.ZINDEX_CHANGE, model_zIndexChangeHandler);
}

private function model_zIndexChangeHandler(event:PlanetObjectEvent) : void
{
   setDepth();
}