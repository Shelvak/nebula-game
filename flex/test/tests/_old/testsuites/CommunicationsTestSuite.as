package tests._old.testsuites
{
	import net.digitalprimates.fluint.tests.TestSuite;
	
	import tests._old.utils.remote.rmo.RMOClassesTest;
	
   
	public class CommunicationsTestSuite extends TestSuite
	{
		public function CommunicationsTestSuite()
		{
		   super();
		   addTestCase (new RMOClassesTest ());
		}
	}
}