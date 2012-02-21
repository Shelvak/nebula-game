/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 2/15/12
 * Time: 12:14 PM
 * To change this template use File | Settings | File Templates.
 */
package models.objectives
{
   import utils.locale.Localizer;

   public class BeInAlliance extends ObjectivePart
   {
      public function BeInAlliance(_objective:Objective)
      {
         super(_objective);
      }

      public override function get objectiveText(): String
      {
         var result: String = Localizer.string('Objectives', 'objectiveText.'+objective.type);
         if (result == null || result == '')
         {
            throw new Error('Objective '+ objective.type + ' text was not resolved');
         }
         return result;
      }
   }
}
