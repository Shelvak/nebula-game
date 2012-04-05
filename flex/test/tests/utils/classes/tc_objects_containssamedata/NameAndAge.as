package tests.utils.classes.tc_objects_containssamedata
{
   public class NameAndAge
   {
      public function NameAndAge(name: String, age: int) {
         this.realName = name;
         this.age = age;
      }

      [Required(alias="name")] public var realName: String;
      [Required] public var age: int;
   }
}
