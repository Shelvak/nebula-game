package tests._old.testsuits
{
	import net.digitalprimates.fluint.tests.TestSuite;
	
	import tests._old.utils.remote.ServerConnectorTest;
	import tests._old.utils.remote.rmo.RMOClassesTest;
	
	public class CommunicationsTestSuite extends TestSuite
	{
		public function CommunicationsTestSuite()
		{
		   super ();
		   
		   addTestCase (new RMOClassesTest ());
		   addTestCase (new ServerConnectorTest ());
		}
	}
}