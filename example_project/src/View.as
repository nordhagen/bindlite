package
{
	import com.bit101.components.RadioButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Oyvind Nordhagen
	 * @date 1. mars 2011
	 */
	public class View extends Sprite
	{
		private var _controller:Controller;
		private var _outputField:TextField;
		private var _rbOne:RadioButton;
		private var _rbTwo:RadioButton;

		public function View ( controller:Controller )
		{
			_controller = controller;
			_build();
		}

		/*
		 * EXAMPLE: Using setter instead of making _outputField public
		 * to hide the views implementation of displaying the value.
		 */
		public function set message ( value:String ):void
		{
			_outputField.text = value;
		}

		private function _build ():void
		{
			_drawRadioButtons();
			_drawOutputField();
		}

		private function _drawRadioButtons ():void
		{
			_rbOne = new RadioButton( this, 0, 0, "Button One", true, _controller.radioButtonHandler );
			_rbTwo = new RadioButton( this, _rbOne.x + _rbOne.width + 20, 0, "Button Two", true, _controller.radioButtonHandler );
		}

		private function _drawOutputField ():void
		{
			_outputField = new TextField();
			_outputField.defaultTextFormat = new TextFormat( "_typewriter", 14, 0x666666 );
			_outputField.y = 40;
			_outputField.border = true;
			_outputField.width = 300;
			_outputField.height = 40;
			addChild( _outputField );
		}
	}
}
