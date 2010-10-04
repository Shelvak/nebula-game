package components.resourcesbar
{
	import com.developmentarc.core.utils.EventBroker;
	
	import components.base.BaseContainer;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import globalevents.GResourcesEvent;
	
	import models.resource.ResourcesMods;

	public class ResourcesBarClass extends BaseContainer
	{
		public var metalBar: ResourceBar;
		public var energyBar: ResourceBar;
		public var zetiumBar: ResourceBar;
        private var _timer: Timer;  //timer for increasment;   
        private var prepTimer: Timer; //timer for first increasment;
        private const TIMER_INTERVAL:int = 1000;
		
		public function IncreaseStocks(evt:TimerEvent = null):void
		{
         iterateIncresement();
         
            if (_timer == null)
            {
                _timer = new Timer(TIMER_INTERVAL);
                _timer.addEventListener(TimerEvent.TIMER, IncreaseStocks);
                _timer.start();
            }
            
		}
		
		public function stopRateIncreasement():void{
            if (_timer)
            {
			 _timer.stop();
			 _timer = null;
            }
		}
      
      private function iterateIncresement(seconds: int = 1): void
      {
         //=================METAL======================
         //IF NEXT VALUE WILL BE LESS THEN ZERO
         if (metalBar._model.currentStock + (metalBar._model.rate * seconds) < 0)
         {
            if (metalBar._model.currentStock != 0)
               metalBar._model.currentStock = 0;
         }
            //IF NEXT VALUE WILL BE MORE THEN MAX
         else if (metalBar._model.currentStock + (metalBar._model.rate * seconds)> metalBar._model.maxStock) 
         {
            if ( metalBar._model.currentStock != metalBar._model.maxStock)
               metalBar._model.currentStock = metalBar._model.maxStock;
         }
            //SET CURRENT VALUE
         else metalBar._model.currentStock = metalBar._model.currentStock + (metalBar._model.rate * seconds); 
         
         //==============ENERGY===================
         //IF NEXT VALUE WILL BE LESS THEN ZERO
         if (energyBar._model.currentStock + (energyBar._model.rate * seconds) < 0)
         {
            if (energyBar._model.currentStock != 0)
               energyBar._model.currentStock = 0;
         }
            //IF NEXT VALUE WILL BE MORE THEN MAX
         else if (energyBar._model.currentStock + (energyBar._model.rate * seconds)> energyBar._model.maxStock) 
         {
            if ( energyBar._model.currentStock != energyBar._model.maxStock)
               energyBar._model.currentStock = energyBar._model.maxStock;
         }
            //SET CURRENT VALUE
         else energyBar._model.currentStock = energyBar._model.currentStock + (energyBar._model.rate * seconds); 
         
         //==============ZETIUM===================
         //IF NEXT VALUE WILL BE LESS THEN ZERO
         if (zetiumBar._model.currentStock + (zetiumBar._model.rate * seconds) < 0)
         {
            if (zetiumBar._model.currentStock != 0)
               zetiumBar._model.currentStock = 0;
         }
            //IF NEXT VALUE WILL BE MORE THEN MAX
         else if (zetiumBar._model.currentStock + (zetiumBar._model.rate * seconds)> zetiumBar._model.maxStock) 
         {
            if ( zetiumBar._model.currentStock != zetiumBar._model.maxStock)
               zetiumBar._model.currentStock = zetiumBar._model.maxStock;
         }
            //SET CURRENT VALUE
         else zetiumBar._model.currentStock = zetiumBar._model.currentStock + (zetiumBar._model.rate * seconds);
         
         new GResourcesEvent(GResourcesEvent.RESOURCES_CHANGE);
      }
      
      public function sync(seconds: int): void
      {
            iterateIncresement(seconds);
      }
		
      protected function handleUpdate(e: GResourcesEvent): void
      {
         prepTimer = new Timer(e.timePassed % 1000, 1);
         prepTimer.addEventListener(TimerEvent.TIMER, IncreaseStocks);
         prepTimer.start();
         sync(e.timePassed/1000);
      }
		
		public function ResourcesBarClass()
		{
			super();
         EventBroker.subscribe(GResourcesEvent.UPDATE, handleUpdate);
		}
	}
}