package utils.datastructures.editors
{
   import mx.collections.IList;
   
   import utils.Objects;
   import utils.TypeChecker;

   /**
    * Factory of collection editors. Supported collections are:
    * <code>
    * <ul>
    *    <li>Array</li>
    *    <li>Vector</li>
    *    <li>IList</li>
    * </ul>
    * </code>
    */
   public class ICollectionEditorFactory
   {
      /**
       * Creates an editor for the given collection.
       * 
       * @param collection collection to create editor for. <b>Not null</b>.
       */
      public static function getEditor(collection:*) : ICollectionEditor
      {
         Objects.paramNotNull("collection", collection);
         if (collection is Array)
            return arrayEditor(collection);
         if (TypeChecker.isVector(collection))
            return vectorEditor(collection);
         if (collection is IList)
            return listEditor(collection);
         throw new ArgumentError("Unsupported collection type: " + Objects.getClassName(collection));
      }
      
      private static function arrayEditor(a:Array) : ICollectionEditor {
         return new ArrayEditor(a);
      } 
      
      private static function vectorEditor(v:Object) : ICollectionEditor {
         return new VectorEditor(v);
      }
      
      private static function listEditor(l:IList) : ICollectionEditor {
         return new ListEditor(l);
      }
   }
}