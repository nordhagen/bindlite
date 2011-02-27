package com.oynor.bindlite
{
	import flash.utils.getQualifiedClassName;

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
		internal var isDirty:Boolean;

		public function Binding ( name:String, source:Object, dataType:Class = null, compareFuction:Function = null )
		{
			this.dataType = dataType;
			this.source = source;
			this.key = name;
			this.compareFuction = compareFuction;
		}

		public function get value ():*
		{
			return source[key];
		}

		public function set value ( val:* ):void
		{
			if (val is dataType)
			{
				if (compareFuction != null)
				{
					isDirty = compareFuction.apply( null, [ val, source[key] ] );
					if (isDirty) source[key] = val;
				}
				else if (source[key] !== val)
				{
					source[key] = val;
					isDirty = true;
				}
			}
			else
			{
				throw new ArgumentError( "Type mismatch in binding " + key + ". Expected " + getQualifiedClassName( dataType ) + ", was " + getQualifiedClassName( val ) );
			}
		}
	}
}
