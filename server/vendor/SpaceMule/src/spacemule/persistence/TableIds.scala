/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package spacemule.persistence

class TableIds(var current: Int) {
  def next: Int = {
    current += 1
    return current
  }
}
