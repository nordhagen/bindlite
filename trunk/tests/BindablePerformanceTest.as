package
{
	import com.gskinner.performance.ptest;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import no.olog.Olog;
	import objects.BindableTarget;

	/**
	 * @author Oyvind Nordhagen
	 * @date 27. feb. 2011
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="800", height="600")]
	[Bindable]
	public class BindablePerformanceTest extends Sprite
	{
		public var testString:String = "binding";
		public var counter:uint = 0;
		private var targetOne:BindableTarget;
		private var targetTwo:BindableTarget;

		public function BindablePerformanceTest ()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addChild( Olog.window );

			targetOne = new BindableTarget( this );
			targetTwo = new BindableTarget( this );

			Olog.trace( "test start" );
			Olog.trace( ptest( update, null, "Bindable Update", 5, 100000 ) );
		}

		public function update ():void
		{
			testString = "binding" + (++counter);
		}
	}
}
