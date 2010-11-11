import models.battle.events.ParticipantEvent;

private var _actualHp: int;

public function get actualHp() : int
{
   return _actualHp;
}


public function set actualHp(value: int) : void
{
   if (value <= 0)
   {
      _actualHp = 0;
   }
   else
   {
      _actualHp = value;
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