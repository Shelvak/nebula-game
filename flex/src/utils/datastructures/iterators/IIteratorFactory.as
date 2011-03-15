package utils.datastructures.iterators
{
   import mx.collections.IList;
   
   import org.hamcrest.mxml.collection.Array;
   
   import utils.ClassUtil;
   import utils.TypeChecker;

   
   public class IIteratorFactory
   {
      public static function getIterator(collection:*) : IIterator
      {
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
      
      
      private static function arrayIterator(array:Array) : IIterator
      {
         return new ArrayIterator(array);
      }
      
      
      private static function vectorIterator(vector:Vector) : IIterator
      {
         return new VectorIterator(vector);
      }
      
      
      private static function listIterator(list:IList) : IIterator
      {
         return new ListIterator(list);
      }
   }
}