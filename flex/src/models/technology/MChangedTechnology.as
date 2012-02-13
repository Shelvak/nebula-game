/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 1/31/12
 * Time: 6:20 PM
 * To change this template use File | Settings | File Templates.
 */
package models.technology {
   public class MChangedTechnology {
      public function MChangedTechnology(type: String,  
                                         _oldScientists: int = -1, 
                                         _newScientists: int = -1) {
         technology = type;
         paused = _newScientists == -1;
         oldScientists = _oldScientists;
         newScientists = _newScientists;
      }
      [Bindable]
      public var technology: String;
      [Bindable]
      public var paused: Boolean = false;
      [Bindable]
      public var oldScientists: int;
      [Bindable]
      public var newScientists: int;
   }
}
