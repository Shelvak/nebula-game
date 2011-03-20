package tests.utils.tests
{
   import mx.resources.IResourceBundle;
   import mx.resources.ResourceBundle;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.equalTo;
   
   import utils.locale.Localizer;
   
   public class TCLocalizer
   {
      
      [Before]
      public function setUp() : void
      {
         var bundle: ResourceBundle = new ResourceBundle('en_US', 'Test');
         bundle.content['simple'] = 'simpleString';
         bundle.content['params'] = 'simple {0} string';
         bundle.content['referenced'] = 'simple [reference:ref.notString] string';
         bundle.content['ref.notString'] = 'not';
         bundle.content['ref.real'] = 'realy';
         bundle.content['chained'] = 'simple [reference:Test2/ref.notString] string';
         bundle.content['chainedParams'] = 'simple [reference:Test2/ref.notString] {0} string';
         Localizer.addBundle(bundle);
         
         var bundle2: ResourceBundle = new ResourceBundle('en_US', 'Test2');
         bundle2.content['ref.notString'] = 'not [reference:Test/ref.real]';
         Localizer.addBundle(bundle2);
      };
      
      [Test]
      public function findSimpleString() : void
      {
         assertThat(Localizer.string('Test', 'simple'), equalTo("simpleString"));
      }
      
      [Test]
      public function findStringWithParams() : void
      {
         assertThat(Localizer.string('Test', 'params', [12]), equalTo("simple 12 string"));
      }
      
      [Test]
      public function findStringWithReference() : void
      {
         assertThat(Localizer.string('Test', 'referenced'), equalTo("simple not string"));
      }
      
      [Test]
      public function findChainedStringWithReference() : void
      {
         assertThat(Localizer.string('Test', 'chained'), equalTo("simple not realy string"));
      }
      
      [Test]
      public function findChainedStringWithReferenceAndParams() : void
      {
         assertThat(Localizer.string('Test', 'chainedParams', [12]), equalTo("simple not realy 12 string"));
      }
   }
}