package tests.models
{
   import tests.models.tests.TCBaseModel;
   import tests.models.tests.TCObjectives;
   import tests.models.tests.TCResource;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSModels
   {
      public var tcBaseModel:TCBaseModel;
      public var tcResource: TCResource;
      public var tcObjectives: TCObjectives;
   }
}