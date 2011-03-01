package
{
	import com.bit101.components.RadioButton;
	import com.oynor.bindlite.BindLite;
	import flash.events.Event;

	/**
	 * @author Oyvind Nordhagen
	 * @date 1. mars 2011
	 */
	public class Controller
	{
		public function radioButtonHandler ( e:Event ):void
		{
			var rb:RadioButton = e.target as RadioButton;
			
			/*
			 * Updating the bound property based on which radio button was clicked.
			 * During this process a data type check is performed and an error is
			 * thrown if the new value's type does not match that of the binding.
			 */
			BindLite.update( Bindable.MESSAGE, rb.label + " was clicked" );
		}
	}
}
