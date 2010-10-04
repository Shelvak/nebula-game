import config.Config;

import utils.StringUtil;

private var _type: String;

[Required]
public function set type(value:String) : void
{
	_type = value;
}

public function get type() : String
{
	return _type;
}

private var _hp:int = 0;
[Required]
public function set hp(value:int) : void
{
   if (value < 0)
   {
      _hp = 0;
   }
   else
   {
	   _hp = value;
   }
}
public function get hp() : int
{
	return _hp;
}

public function get maxHp(): int
{
	return StringUtil.evalFormula(Config.getUnitHp(type), {'level': level});
}

public function get kind(): String
{
	return Config.getUnitKind(type);
}