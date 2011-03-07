/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.modules.pmg.objects.solar_systems

import spacemule.modules.pmg.objects.SolarSystem

class Wormhole extends SolarSystem {
  override val wormhole = true

  /**
   * Wormholes do not have any objects inside them.
   */
  override def createObjects() = {}
}
