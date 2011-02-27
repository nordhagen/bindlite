package
{
	import com.gskinner.performance.ptest;
	import com.oynor.bindlite.BindLite;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import no.olog.Olog;
	import objects.BindLIteTarget;

	/**
	 * @author Oyvind Nordhagen
	 * @date 27. feb. 2011
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="800", height="600")]
	public class BindLitePerformanceTest extends Sprite
	{
		public var testString:String = "binding";
		public var counter:uint = 0;
		private var targetOne:BindLIteTarget;
		private var targetTwo:BindLIteTarget;

		public function BindLitePerformanceTest ()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addChild( Olog.window );

			targetOne = new BindLIteTarget();
			targetTwo = new BindLIteTarget();

			BindLite.define( "testString", this );

			BindLite.bind( "testString", targetOne );
			BindLite.bind( "testString", targetTwo );
			
			Olog.trace("test start");
			Olog.trace( ptest( update, null, "BindLite Update", 5, 100000 ) );
		}

		public function update ():void
		{
			BindLite.update( "testString", "binding" + (++counter) );
		}
	}
}
