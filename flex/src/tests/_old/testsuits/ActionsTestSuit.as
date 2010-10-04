package tests._old.testsuits
{
   import net.digitalprimates.fluint.tests.TestSuite;
   
   import tests._old.controllers.messages.*;




	public class ActionsTestSuit extends TestSuite
	{
		public function ActionsTestSuit ()
		{
		   super ();
		   
		   addTestCase (new MessageRecievedActionTest ());
		}
	}
}