package com.oynor.bindlite
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * Minimal replacement for Flex data binding using <code>[Bindable]</code> meta.  
	 * @author Oyvind Nordhagen
	 * @date 4. feb. 2011
	 */
	public class BindLite
	{
		private static var _bindings:Dictionary = new Dictionary( true );

		/**
		 * Defines a new binable property as a string representation of an available property on the source argument.
		 * This property must be either a public var or getter/setter pair.
		 * @param key The property name 
		 * @param source The object containing the property
		 * @param compareFunction Referance to a function that takes two instances of this binding's datatype as arguments and returns true if they are equal
		 * @return void
		 */
		public static function define ( key:String, source:Object, compareFunction:Function = null ):void
		{
			_initBinding( source, key, compareFunction );
		}

		/**
		 * Changes the value of a bindable property and propagates the change to all bound targets if new value differs from old. 
		 * @param key The predefined bindable property name
		 * @param value The new value
		 * @return void
		 */
		public static function update ( key:String, value:* ):void
		{
			var binding:Binding = _getBinding( key );
			binding.value = value;
			if (binding.isDirty)
			{
				_propagate( binding );
			}
		}

		/**
		 * Binds a target to a bindable property. The target object must contain a public var or a setter by the same name as the bindable property.
		 * @param key The predefined bindable property name
		 * @param target The target object to push changes to the property value to
		 * @param initialPush If true, updates the property on the target immediately after binding
		 * @return void
		 */
		public static function bind ( key:String, target:Object, initialPush:Boolean = false ):void
		{
			var binding:Binding = _getBinding( key );
			_validateBindable( target, key, binding );
			_getBinding( key ).targets.push( target );
			if (initialPush) target[key] = _getBinding( key ).value;
		}

		/**
		 * Removes a target from binding(s). Specifying a property to unbind is optional. Without a key argument, the target will be removed from
		 * all bindings, effectively releasing it from data binding all together. 
		 * @param target The object to remove a binding from
		 * @param key Optional predefined bindable property name. If specified, only this binding is removed.
		 * @return void
		 */
		public static function unbind ( target:Object, key:String = null ):void
		{
			if (key)
			{
				var binding:Binding = _getBinding( key );
				binding.targets.splice( binding.targets.indexOf( target ), 1 );
			}
			else
			{
				_unbindTargetFromAllKeys( target );
			}
		}

		/**
		 * Retrieves the value of a bindable property manually
		 * @param key The predefined bindable property name
		 * @return void
		 */
		public static function retrieve ( key:String ):*
		{
			return _getBinding( key ).value;
		}

		private static function _propagate ( binding:Binding ):void
		{
			for each (var target:Object in binding.targets)
			{
				target[binding.key] = binding.value;
			}
			binding.isDirty = false;
		}

		private static function _getBinding ( key:String ):Binding
		{
			if (_bindings[key] != undefined)
			{
				return _bindings[key];
			}
			else
			{
				throw new ArgumentError( "No binding named \"" + key + "\"" );
			}
		}

		private static function _unbindTargetFromAllKeys ( target:Object ):void
		{
			for (var key:String in _bindings)
			{
				var binding:Binding = _bindings[key];
				if (binding.targets.indexOf( target ) != -1)
				{
					binding.targets.splice( binding.targets.indexOf( target ), 1 );
				}
			}
		}

		private static function _initBinding ( source:Object, key:String, compareFunction:Function = null ):void
		{
			if (_bindings[key] != undefined)
			{
				throw new IllegalOperationError( "Bindable key \"" + key + "\" is already defined" );
			}

			var def:XML = describeType( source );
			var dataTypeName:String;
			if (def.variable.(@name == key).length() > 0)
			{
				dataTypeName = def.variable.(@name == key)[0].@type;
			}
			else if (def.accessor.(@name == key).length() > 0)
			{
				if (def.accessor.(@name == key)[0].access == "readwrite")
				{
					dataTypeName = def.accessor.(@name == key)[0].@type;
				}
				else
				{
					throw new ArgumentError( "Accessor \"" + key + "\" in " + source + " is read or write only" );
				}
			}
			else
			{
				throw new ArgumentError( "No key/accessor named \"" + key + "\" in " + source );
			}

			_bindings[key] = new Binding( key, source, getDefinitionByName( dataTypeName ) as Class, compareFunction );
		}

		private static function _validateBindable ( target:Object, key:String, binding:Binding ):void
		{
			var def:XML = describeType( target );
			var dataTypeName:String;
			if (def.variable.(@name == key).length() > 0)
			{
				dataTypeName = def.variable.(@name == key)[0].@type;
			}
			else if (def.accessor.(@name == key).length() > 0)
			{
				if (def.accessor.(@name == key)[0].@access.indexOf( "write" ) != -1)
				{
					dataTypeName = def.accessor.(@name == key)[0].@type;
				}
				else
				{
					throw new ArgumentError( "Accessor \"" + key + "\" in " + target + " is read only" );
				}
			}
			else
			{
				throw new ArgumentError( "No property/accessor named \"" + key + "\" in " + target );
			}

			if (binding.dataType !== getDefinitionByName( dataTypeName ))
			{
				throw new ArgumentError( "Binding data type mismatch on key \"" + key + "\" from " + binding.source + " to " + target );
			}
		}
	}
}
