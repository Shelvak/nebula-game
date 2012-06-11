package spacemule.modules.pmg.objects

case class Player(name: String, webUserId: Long) {
  override def toString = "<Player webUserId:"+webUserId+" name:"+name+">"
}