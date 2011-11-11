package com.oynor.bindlite {
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Replacement for Flex data binding. For smaller applications needing only one
	 * model consider BindLite at http://www.oynor.com/blog/bindlite  
	 * @author Oyvind Nordhagen
	 * @date 26. may 2011
	 */
	public class BindMax {
		private var _autoDisposeBindings:Boolean;
		protected var bindings:Dictionary = new Dictionary( true );
		protected var classDefinition:XML;

		/**
		 * Constructor. Can enumerate all publicly accessible properties, including those defined
		 * by getter/setter pairs, and initialize bindings for them.
		 * @param autoEnumerate Enumerates bindings upon instantiation if true (default)   
		 * @return BindMax instance
		 */
		public function BindMax ( autoEnumerate:Boolean = true, allowNull:Boolean = true ) {
			classDefinition = describeType( this );
			if (autoEnumerate) _enumerateBindings( allowNull );
		}

		/**
		 * Sets the compare function for a binding. 
		 * @param key The property name 
		 * @param compareFunction Reference to a function that takes two instances of this binding's datatype as arguments and returns true if they are equal
		 * @return void
		 */
		public function setCompareFunction ( key:String, compareFunction:Function ):void {
			getBinding( key ).compareFuction = compareFunction;
		}

		/**
		 * Returns the compare function defined for a binding. 
		 * @param key The property name
		 * @return Function or null if not defined
		 */
		public function getCompareFunction ( key:String ):Function {
			return getBinding( key ).compareFuction;
		}

		/**
		 * Changes the value of a bindable property and propagates the change to all bound targets if new value differs from old. 
		 * @param key The predefined bindable property name
		 * @param value The new value
		 * @return void
		 */
		public function update ( key:String, value:*, forcePropagation:Boolean = false ):void {
			var binding:Binding = getBinding( key );
			if ((value != null || binding.allowNull) || value is binding.dataType) {
				if (forcePropagation || binding.forcePropagation || !binding.equals( value )) {
					binding.lastValue = clone( binding.value );
					binding.value = value;
					propagate( binding );
				}
			}
			else {
				throw new ArgumentError( "Type mismatch in binding \"" + key + "\". Expected " + getQualifiedClassName( binding.dataType ) + ", was " + getQualifiedClassName( value ) );
			}
		}

		/**
		 * Binds a target to a bindable property. The target object must contain a public var or a setter by the same name as the bindable property.
		 * @param key The predefined bindable property name
		 * @param target The target object to push changes to the property value to
		 * @param initialPush If true, updates the property on the target immediately after binding
		 * @return void
		 */
		public function bind ( key:String, target:Object, initialPush:Boolean = false ):void {
			if (!hasBinding( key, target )) {
				var binding:Binding = getBinding( key );
				_validateBindable( target, key, binding );
				getBinding( key ).targets.push( target );
				if (initialPush) target[key] = getBinding( key ).value;
			}
			else {
				trace( "Warning: Attempted duplicate binding from " + target + " to " + key );
			}
		}

		/**
		 * Returns true if the specified binding exists, false if not
		 * @param key The predefined bindable property name
		 * @param target The target object to check agains the binding
		 * @return void
		 */
		public function hasBinding ( key:String, target:Object ):Boolean {
			var binding:Binding = getBinding( key );

			for each (var boundTarget:Object in binding.targets) {
				if (getQualifiedClassName( boundTarget ) == getQualifiedClassName( target )) {
					return true;
				}
			}
			return false;
		}

		/**
		 * Removes a target from binding(s). Specifying a property to unbind is optional. Without a key argument, the target will be removed from
		 * all bindings, effectively releasing it from data binding all together. 
		 * @param target The object to remove a binding from
		 * @param key Optional predefined bindable property name. If specified, only this binding is removed.
		 * @return void
		 */
		public function unbind ( target:Object, key:String = null ):void {
			if (key) {
				var binding:Binding = getBinding( key );
				binding.targets.splice( binding.targets.indexOf( target ), 1 );
				if (_autoDisposeBindings) evalAutoDispose( binding );
			}
			else {
				unbindTargetFromAllKeys( target );
			}
		}

		/**
		 * Retrieves the value of a bindable property manually
		 * @param key The predefined bindable property name
		 * @return Value of bound property
		 */
		public function retrieve ( key:String ):* {
			return getBinding( key ).value;
		}

		/**
		 * Retrieves the previous value of a bindable property
		 * @param key The predefined bindable property name
		 * @return Previous value of bound property
		 */
		public function retrieveLast ( key:String ):* {
			return getBinding( key ).lastValue;
		}
		
		/**
		 * Manually removes the data binding
		 * @param key The predefined bindable property name of the binding
		 */
		public function disposeBinding ( key:String ):void {
			dispose( getBinding( key ) );
		}
		
		/**
		 * Defines whether bindings are automatically disposed when their list of listeners goes empty
		 */
		public function get autoDisposeBindings ():Boolean {
			return _autoDisposeBindings;
		}

		/**
		 * Defines whether bindings are automatically disposed when their list of listeners goes empty
		 */
		public function set autoDisposeBindings ( autoDisposeBindings:Boolean ):void {
			_autoDisposeBindings = autoDisposeBindings;
			if (_autoDisposeBindings) {
				for each (var binding:Binding in bindings) {
					evalAutoDispose( binding );
				}
			}
		}
		
		/**
		 * Resets the supplied binding keys to the value they had at the time they were defined
		 * @param keys Comma separated list of predefined bindable property names
		 */
		public function reset ( ...keys ):void {
			for each (var key:String in keys) {
				bindings[key].reset();
			}
		}

		protected function evalAutoDispose ( binding:Binding = null ):void {
			if (binding && binding.targets.length == 0) {
				dispose( binding );
			}
			else {
				for each (binding in bindings) {
					if (binding.targets.length == 0) dispose( binding );
				}
			}
		}

		protected function dispose ( binding:Binding ):void {
			delete bindings[binding.key];
			binding.dispose();
		}

		protected function clone ( value:* ):* {
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject( value );
			myBA.position = 0;
			return(myBA.readObject());
		}

		protected function propagate ( binding:Binding ):void {
			for each (var target:Object in binding.targets) {
				target[binding.key] = binding.value;
			}
		}

		protected function getBinding ( key:String ):Binding {
			if (bindings[key] != undefined) {
				return bindings[key];
			}
			else {
				throw new ArgumentError( "No binding named \"" + key + "\"" );
			}
		}

		protected function unbindTargetFromAllKeys ( target:Object ):void {
			for (var key:String in bindings) {
				var binding:Binding = bindings[key];
				if (binding.targets.indexOf( target ) != -1) {
					binding.targets.splice( binding.targets.indexOf( target ), 1 );
					if (_autoDisposeBindings) evalAutoDispose( binding );
				}
			}
		}

		/**
		 * Defines a new binable property as a string representation of an available property on the source argument.
		 * This property must be either a public var or getter/setter pair.
		 * @param key The property name 
		 * @param compareFunction Reference to a function that takes two instances of this binding's datatype as arguments and returns true if they are equal
		 * @return void
		 */
		protected function define ( key:String, allowNull:Boolean = true, forcePropagation:Boolean = false, compareFunction:Function = null ):void {
			if (bindings[key] != undefined) {
				throw new IllegalOperationError( "Bindable key \"" + key + "\" is already defined" );
			}

			var dataTypeName:String;
			if (classDefinition.variable.(@name == key).length() > 0) {
				dataTypeName = classDefinition.variable.(@name == key)[0].@type;
			}
			else if (classDefinition.accessor.(@name == key).length() > 0) {
				if (classDefinition.accessor.(@name == key)[0].@access == "readwrite") {
					dataTypeName = classDefinition.accessor.(@name == key)[0].@type;
				}
				else {
					throw new ArgumentError( "Accessor \"" + key + "\" is read or write only" );
				}
			}
			else {
				throw new ArgumentError( "No property/accessor named \"" + key + "\"" );
			}

			bindings[key] = new Binding( key, this, getDefinitionByName( dataTypeName ) as Class, allowNull, forcePropagation, compareFunction );
		}

		private function _enumerateBindings ( allowNull:Boolean = true ):void {
			var publiclyAccessibleData:XMLList = classDefinition.variable + classDefinition.accessor.(@access == "readwrite");
			var key:String;
			for each (var item:XML in publiclyAccessibleData) {
				key = item.@name;
				bindings[key] = new Binding( key, this, getDefinitionByName( item.@type ) as Class, allowNull );
			}
		}

		private function _validateBindable ( target:Object, key:String, binding:Binding ):void {
			var def:XML = describeType( target );
			var dataTypeName:String;
			if (def.variable.(@name == key).length() > 0) {
				dataTypeName = def.variable.(@name == key)[0].@type;
			}
			else if (def.accessor.(@name == key).length() > 0) {
				if (def.accessor.(@name == key)[0].@access.indexOf( "write" ) != -1) {
					dataTypeName = def.accessor.(@name == key)[0].@type;
				}
				else {
					throw new ArgumentError( "Accessor \"" + key + "\" in " + target + " is read only" );
				}
			}
			else {
				throw new ArgumentError( "No property/accessor named \"" + key + "\" in " + target );
			}

			if (binding.dataType !== getDefinitionByName( dataTypeName )) {
				throw new ArgumentError( "Binding data type mismatch on key \"" + key + "\" from " + binding.source + " to " + target );
			}
		}
	}
}
