package objects{
	/**
	 * @author Oyvind Nordhagen
	 * @date 16. feb. 2011
	 */
	public class BindLIteTarget {
		public var testString:String;
		private var _testUint:uint;

		public function set testUint ( testUint:uint ):void {
			_testUint = testUint;
			trace( this + " recieved " + testUint );
		}

		public function get testUint ():uint {
			return _testUint;
		}
	}
}
