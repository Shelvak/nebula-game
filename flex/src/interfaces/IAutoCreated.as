/**
 * Created by IntelliJ IDEA.
 * User: MikisM
 * Date: 11.11.29
 * Time: 15.21
 * To change this template use File | Settings | File Templates.
 */
package interfaces
{
   /**
    * Objects that should do some postprocessing themselves after they have
    * been constructed using <code>Objects.create()</code> should implement
    * this interface.
    */
   public interface IAutoCreated
   {
      /**
       * Called after an instance has been constructed by
       * <code>Objects.create()</code> method.
       *
       * @param data generic object that holds all data that was used
       * while constructing the instance
       */
      function afterCreate(data:Object): void;
   }
}
