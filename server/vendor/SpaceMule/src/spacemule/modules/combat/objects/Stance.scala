/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.combat.objects

object Stance extends Enumeration {
  type Type = Value

  val Normal = Value(0, "normal")
  val Defensive = Value(1, "defensive")
  val Aggressive = Value(2, "aggresive")
}
