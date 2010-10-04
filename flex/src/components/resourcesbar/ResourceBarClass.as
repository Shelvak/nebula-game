package components.resourcesbar
{
	import components.base.BaseContainer;
	
	import spark.primitives.BitmapImage;

	[Bindable]
	public class ResourceBarClass extends BaseContainer
	{
		public var image: BitmapImage;
		public var bar: ResourcesProgressBar;
		public var imageSource: String;
		
		public function setImage(iconSource: String):void{
			imageSource = iconSource;
		}
		
		public function ResourceBarClass():void
		{
			super();
		}
	}
}