package
{
	import com.oynor.bindlite.BindLite;

	/**
	 * @author Oyvind Nordhagen
	 * @date 1. mars 2011
	 */
	public class Model extends BindLite
	{
		private var _message:String = "No button clicked yet";

		public function Model ()
		{
			/*
			 * Defining the property as bindable is the first and crucial step.
			 * BindLite will look for a public property or getter/setter pair matching
			 * the value of the key argument (Bindable.MESSAGE = "message") in the
			 * source parameter ("this") and throw an error if it doesn't exist or is
			 * read or write only.
			 * 
			 * The data type for the binding is set based on the type of the property as
			 * found by this statement.
			 */
			define( Bindable.MESSAGE, this );
		}

		public function get message ():String
		{
			return _message;
		}

		public function set message ( newMessage:String ):void
		{
			/*
			 * EXAMPLE: Using setter instead of public variable to ensure
			 * that message length does not exceed 30 characters
			 */
			if (newMessage.length > 30)
			{
				_message = newMessage.substr( 0, 30 );
			}
			else
			{
				_message = newMessage;
			}
		}
	}
}
