package tests._old.testsuits
{
	import net.digitalprimates.fluint.tests.TestSuite;
	
	import tests._old.controllers.messages.ServerCommandsDispatcherTest;
	
	
	
	
	public class ControllersLogicTestSuite extends TestSuite
	{
		public function ControllersLogicTestSuite()
		{
		   super ();
		   
		   addTestCase (new ServerCommandsDispatcherTest ());
		}
	}
}