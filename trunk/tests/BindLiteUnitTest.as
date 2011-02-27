package
{
	import com.oynor.bindlite.BindLite;
	import enum.Binding;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import no.olog.Olog;
	import no.olog.utilfunctions.assert;
	import no.olog.utilfunctions.otrace;
	import objects.BindLIteTarget;

	/**
	 * @author Oyvind Nordhagen
	 * @date 16. feb. 2011
	 */
	public class BindLiteUnitTest extends Sprite
	{
		public var testString:String;
		public var testUint:uint;

		public function BindLiteUnitTest ()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addChild( Olog.window );

			var targetOne:BindLIteTarget = new BindLIteTarget();
			var targetTwo:BindLIteTarget = new BindLIteTarget();

			BindLite.define( Binding.TEST_STRING, this );
			BindLite.define( Binding.TEST_UINT, this );

			BindLite.bind( Binding.TEST_STRING, targetOne );
			BindLite.bind( Binding.TEST_UINT, targetOne );

			BindLite.bind( "testString", targetTwo, true );
			BindLite.bind( "testUint", targetTwo, true );

			assert( "testString target one", testString, targetOne.testString );
			assert( "testUint target one", testUint, targetOne.testUint );
			assert( "testString target two", testString, targetTwo.testString );
			assert( "testUint target two", testUint, targetTwo.testUint );
			otrace( targetOne + " recieved " + targetOne.testString );
			otrace( targetTwo + " recieved " + targetTwo.testUint );

			BindLite.update( Binding.TEST_STRING, "This string is new" );
			BindLite.update( "testUint", 5 );

			assert( "testString target one", testString, targetOne.testString );
			assert( "testUint target one", testUint, targetOne.testUint );
			assert( "testString target two", testString, targetTwo.testString );
			assert( "testUint target two", testUint, targetTwo.testUint );
			otrace( targetOne + " recieved " + targetOne.testString );
			otrace( targetTwo + " recieved " + targetTwo.testUint );

			BindLite.update( "testString", "This string is new again" );
			BindLite.update( "testUint", 10 );

			assert( "testString target one", testString, targetOne.testString );
			assert( "testUint target one", testUint, targetOne.testUint );
			assert( "testString target two", testString, targetTwo.testString );
			assert( "testUint target two", testUint, targetTwo.testUint );
			otrace( targetOne + " recieved " + targetOne.testString );
			otrace( targetTwo + " recieved " + targetTwo.testUint );
		}
	}
}
