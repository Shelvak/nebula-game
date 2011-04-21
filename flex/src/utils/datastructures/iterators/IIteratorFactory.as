package utils.datastructures.iterators
{
   import mx.collections.IList;
      
   
   import utils.ClassUtil;
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
      public static function getIterator(collection:*) : IIterator
      {
         ClassUtil.checkIfParamNotNull("collection", collection);
         if (collection is Array)
         {
            return arrayIterator(collection);
         }
         if (TypeChecker.isVector(collection))
         {
            return vectorIterator(collection);
         }
         if (collection is IList)
         {
            return listIterator(collection);
         }
         throw new ArgumentError("Unsupported collection type: " + ClassUtil.getClassName(collection));
      }
      
      
      private static function arrayIterator(a:Array) : IIterator
      {
         return new ArrayIterator(a);
      }
      
      
      private static function vectorIterator(v:Object) : IIterator
      {
         return new VectorIterator(v);
      }
      
      
      private static function listIterator(l:IList) : IIterator
      {
         return new ListIterator(l);
      }
   }
}