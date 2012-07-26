package ext.hamcrest.object
{
   import org.hamcrest.Matcher;

   /**
    * Alias to <code>ext.hamcrest.object.equals</code>.
    */
   public function equalTo(value: Object): Matcher {
      return equals(value);
   }
}
