package controllers.market
{
   import controllers.CommunicationCommand;
   
   public class MarketCommand extends CommunicationCommand
   {
      public static const INDEX:String = "market|index";
      
      public static const NEW:String = "market|new";
      
      public static const CANCEL:String = "market|cancel";
      
      public static const BUY:String = "market|buy";
      
      public static const AVG_RATE:String = "market|avg_rate";
      
      
      public function MarketCommand(type:String,
                                      parameters:Object = null,
                                      fromServer:Boolean = false,
                                      eagerDispatch:Boolean = false)
      {
         super(type, parameters, fromServer, eagerDispatch);
      }
   }
}