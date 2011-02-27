package
objects{
	import flash.events.IEventDispatcher;

	/**
	 * @author Oyvind Nordhagen
	 * @date 27. feb. 2011
	 */
	public class BindableTarget
	{
		public var testString:String;

		public function BindableTarget ( source:IEventDispatcher )
		{
			source.addEventListener( "propertyChange", onPropertyChange );
		}

		private function onPropertyChange ( event:Object ):void
		{
			if (event.property == "testString")
				this.testString = event.newValue;
		}
	}
}
