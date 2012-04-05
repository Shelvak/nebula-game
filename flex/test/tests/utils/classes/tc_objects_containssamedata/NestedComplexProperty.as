package tests.utils.classes.tc_objects_containssamedata
{
   public class NestedComplexProperty
   {
      public function NestedComplexProperty(nameAndAge: NameAndAge) {
         this.nameAndAge = nameAndAge;
      }

      [Required] public var nameAndAge: NameAndAge;
   }
}
