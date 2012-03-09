package utils.datastructures.iterators
{
   import mx.collections.IList;
   
   import utils.Objects;
   import utils.TypeChecker;
   
   
   /**
    * Factory of iterators. Supported collections are:
    * <code>
    * <ul>
    *    <li>Array</li>
    *    <li>Vector</li>
    *    <li>IList</li>
    * </ul>
    * </code>
    */
   public class IIteratorFactory
   {
      /**
       * Creates iterator for the given collection.
       * 
       * @param collection instance of a collection. <b>Not null</b>.
       */
      public static function getIterator(collection:*) : IIterator {
         Objects.paramNotNull("collection", collection);
         if (collection is Array) {
            return new ArrayIterator(collection);
         }
         if (TypeChecker.isVector(collection)) {
            return new VectorIterator(collection);
         }
         if (collection is IList) {
            return new ListIterator(collection);
         }
         throw new ArgumentError("Unsupported collection type: " + Objects.getClassName(collection));
      }


   }
}
