import models.planet.MPlanetObject;
import models.planet.events.MPlanetObjectEvent;

private function addModelZIndexChangeHandler(model:MPlanetObject) : void
{
   model.addEventListener(MPlanetObjectEvent.ZINDEX_CHANGE, model_zIndexChangeHandler);
}

private function removeModelZIndexChangeHandler(model:MPlanetObject) : void
{
   model.removeEventListener(MPlanetObjectEvent.ZINDEX_CHANGE, model_zIndexChangeHandler);
}

private function model_zIndexChangeHandler(event:MPlanetObjectEvent) : void
{
   setDepth();
}