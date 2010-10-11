package models
{
   import ext.flex.mx.collections.ArrayCollection;
   
   import mx.collections.IList;
   
   /**
    * <b>IMPORTANT! If you don't need <code>findModel()</code> nor <code>findExactModel()</code>, do
    * not use this class. Use <code>ArrayCollection</code> instead.</b>
    * <p>If above is not the case, bare in your mind these terrible things:
    * <ul>
    *    <li><code>findModel()</code> and <code>findExactModel()</code> need O(n) time</li>
    *    <li><code>addItem()</code> and <code>addItemAt()</code> also need O(n) time because
    *        they use <code>findExactModel()</code></li>
    *    <li>When instantiating <code>ModelsCollection</code>, create an array with all needed items
    *        and then create the collection passing that array for the constructor, unless you do not
    *        have a lot of items (100 or so would be fine, but you can forget about 500 and more)</li>
    * </ul>
    * </p>
    */
   public class ModelsCollection extends ArrayCollection implements IModelsList
   {
      /**
       * Looks for and returns a <code>BaseModel</code> with a given id in a
       * given list.
       * 
       * @param list a list containing instances of <code>BaseModel</code>
       * @param id id of a model
       * 
       * @return <code>BaseModel</code> with a given id or <code>null</code>
       * if one could not be found. 
       */
      public static function findModel(list:IList, id:int) : *
      {
         for each (var item:BaseModel in list)
         {
            if (item != null && item.id == id)
            {
               return item;
            }
         }
         return null;
      }
      
      
      /**
       * Looks for and returns a <code>BaseModel</code> equal to the given model.
       * 
       * @param list a list containing instances of <code>BaseModel</code>
       * @param model model to look fore
       * 
       * @return <code>BaseModel</code> equal to <code>model</code> or <code>null</code> if one
       * can't be found.
       */
      public static function findExactModel(list:IList, model:BaseModel) : *
      {
         for each (var item:BaseModel in list)
         {
            if (item != null && item.equals(model))
            {
               return item;
            }
         }
         return null;
      }
      
      
      include "mixins/defaultIModelsListImpl.as";
      
      
      /**
       * @see mx.collections.ArrayCollection#ArrayCollection()
       * @see ModelsCollection
       */
      public function ModelsCollection(source:Array = null)
      {
         super(source);
      }
   }
}