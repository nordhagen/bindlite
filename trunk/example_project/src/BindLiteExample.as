package
{
	import com.oynor.bindlite.BindLite;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * This class acts as both client and mediator for this simple BindLite example
	 * @author Oyvind Nordhagen
	 * @date 1. mars 2011
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class BindLiteExample extends Sprite
	{
		private var _model:Model;
		private var _controller:Controller;
		private var _view:View;

		public function BindLiteExample ()
		{
			_configureStage();
			_model = new Model();
			_controller = new Controller();

			_view = new View( _controller );
			_view.x = (stage.stageWidth - _view.width) * 0.5;
			_view.y = (stage.stageHeight - _view.height) * 0.5;
			addChild( _view );
			
			/*
			 * Binding the value of "message" to the view.
			 * BindLite will look for a public property or setter by the same name
			 * upon initiating this binding and it will throw an error if it cannot
			 * be found or has a different data type than the source property.
			 * 
			 * Using "initialPush:true" to have BindLite update the view immediately.
			 */
			BindLite.bind( Bindable.MESSAGE, _view, true );
		}

		private function _configureStage ():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
	}
}
