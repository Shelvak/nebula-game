/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 1/30/12
 * Time: 3:51 PM
 * To change this template use File | Settings | File Templates.
 */
package components.resourcetransporter.events {
   import flash.events.Event;

   public class ResourceTransporterEvent extends Event {
      public static const SELECTED_BUILDING_CHANGE: String = 'selectedBuildingChange';
      public static const SELECTED_RESOURCES_CHANGE: String = 'selectedResourcesChange';

      public function ResourceTransporterEvent(type: String) {
         super(type);
      }
   }
}
