/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pathfinder.objects

case class Planet(id: Int, solarSystem: SolarSystem, angle: Int,
                            position: Int) extends Locatable {

}
