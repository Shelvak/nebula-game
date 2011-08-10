package tests.utils.tests
{
   import ext.hamcrest.object.equals;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.nullValue;
   
   import utils.ModelUtil;
   
   
   public class TC_ModelUtil
   {
      [Test]
      public function getModelClass_should_return_model_base_class_name_if_there_is_no_subclass_name() : void
      {
         assertThat( ModelUtil.getModelClass("unit"), equals ("unit") );
         assertThat( ModelUtil.getModelClass("building"), equals ("building") );
      };
      
      
      [Test]
      public function getModelClass_should_return_model_class_name_starting_with_lowercase_letter() : void
      {
         assertThat( ModelUtil.getModelClass("Unit"), equals ("unit") );
         assertThat( ModelUtil.getModelClass("Building"), equals ("building") );
      };
      
      
      [Test]
      public function getModelClass_should_return_model_class_name_starting_with_uppercase_letter_if_firstUppercase_is_true() : void
      {
         assertThat( ModelUtil.getModelClass("unit", true), equals ("Unit") );
         assertThat( ModelUtil.getModelClass("Unit", true), equals ("Unit") );
      };
      
      
      [Test]
      public function getModelClass_should_return_model_base_class_name_if_there_is_also_subclass_name() : void
      {
         assertThat( ModelUtil.getModelClass("unit::Trooper"), equals ("unit") );
         assertThat( ModelUtil.getModelClass("building::Factory"), equals ("building") );
      }
      
      
      [Test]
      public function getModelSubclass_should_fail_if_there_is_no_subclass() : void
      {
         assertThat( function():void{ ModelUtil.getModelSubclass("unit"); }, throws (ArgumentError) );
      };
      
      
      [Test]
      public function getModelSubclass_should_return_null_if_there_is_no_subclass_and_failIfMissing_is_false() : void
      {
         assertThat( ModelUtil.getModelSubclass("unit", false), nullValue() );
         assertThat( ModelUtil.getModelSubclass("building", false), nullValue() );
      };
      
      
      [Test]
      public function getModelSubclass_should_return_model_subclass_name_if_it_has_been_provided() : void
      {
         assertThat( ModelUtil.getModelSubclass("unit::Trooper"), equals ("Trooper") );
         assertThat( ModelUtil.getModelSubclass("building::Factory"), equals ("Factory") );
      };
      
      
      [Test]
      public function getModelType_should_combine_model_class_and_subclass_names_using_two_colons() : void
      {
         assertThat( ModelUtil.getModelType("Unit", "Trooper"), equals ("unit::Trooper") );
         assertThat( ModelUtil.getModelType("Building", "Factory"), equals ("building::Factory") );
      };
      
      
      [Test]
      public function getModelType_should_return_full_type_name_starting_with_lowercase_letter() : void
      {
         assertThat( ModelUtil.getModelType("Unit", "Trooper"), equals ("unit::Trooper") );
         assertThat( ModelUtil.getModelType("unit", "Trooper"), equals ("unit::Trooper") );
         assertThat( ModelUtil.getModelType("Building", "Factory"), equals ("building::Factory") );
         assertThat( ModelUtil.getModelType("building", "Factory"), equals ("building::Factory") );
      };
      
      
      [Test]
      public function getModelType_should_return_full_type_name_starting_with_uppercase_letter_if_firstUppercase_is_true() : void
      {
         assertThat( ModelUtil.getModelType("Unit", "Trooper", true), equals ("Unit::Trooper") );
         assertThat( ModelUtil.getModelType("unit", "Trooper", true), equals ("Unit::Trooper") );
         assertThat( ModelUtil.getModelType("Building", "Factory", true), equals ("Building::Factory") );
         assertThat( ModelUtil.getModelType("building", "Factory", true), equals ("Building::Factory") );
      };
   }
}