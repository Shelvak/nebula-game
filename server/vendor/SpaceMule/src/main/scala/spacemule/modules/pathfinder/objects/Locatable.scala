/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

trait Locatable {
  def toServerLocation(timeMultiplier: Double): ServerLocation
  def toServerLocation: ServerLocation = toServerLocation(1.0)
}
