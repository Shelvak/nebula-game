import models.battle.events.ParticipantEvent;

private var _hpActual: int;

public function get hpActual() : int
{
   return _hpActual;
}


public function set hpActual(value: int) : void
{
   if (value <= 0)
   {
      _hpActual = 0;
   }
   else
   {
      _hpActual = value;
   }
   dispatchActualHpChangeEvent();
}

private function dispatchActualHpChangeEvent(): void
{
   if (hasEventListener(ParticipantEvent.HP_CHANGE))
   {
      dispatchEvent(new ParticipantEvent(ParticipantEvent.HP_CHANGE));
   }
}