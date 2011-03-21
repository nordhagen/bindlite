package com.oynor.bindlite
{
	/**
	 * @author Oyvind Nordhagen
	 * @date 4. feb. 2011
	 */
	internal class Binding
	{
		internal var key:String;
		internal var source:Object;
		internal var dataType:Class;
		internal var targets:Vector.<Object> = new Vector.<Object>();
		internal var compareFuction:Function;
		internal var lastValue:*;

		public function Binding ( name:String, source:Object, dataType:Class = null, compareFuction:Function = null )
		{
			this.dataType = dataType;
			this.source = source;
			this.key = name;
			this.compareFuction = compareFuction;
		}

		internal function get value ():*
		{
			return source[key];
		}

		internal function set value ( val:* ):void
		{
			source[key] = val;
		}

		internal function equals ( val:* ):Boolean
		{
			if (compareFuction != null)
			{
				return compareFuction.apply( null, [ val, source[key] ] );
			}
			else if (source[key] !== val)
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		internal function dispose ():void
		{
			source = null;
			dataType = null;
			compareFuction = null;
			targets.length = 0;
			value = null;
			lastValue = null;
		}
	}
}
