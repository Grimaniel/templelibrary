/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.data.flashvars
{
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.data.collections.HashMap;
	import temple.utils.Enum;

	/**
	 * This class is a Singleton wrapper around the flashvars, so they can be accessed at places where there is no Stage.
	 * <p>You have the possibility to set a default and a class-type for each flashvar individually.</p>
	 * <p>In combination with a FlashVarNames enum class you know which flashvars are used in the application.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * FlashVars.initialize(stage.loaderInfo.parameters);
	 * 
	 * FlashVars.configureVar(FlashVarNames.LANGUAGE, 'nl', String);
	 * FlashVars.configureVar(FlashVarNames.VERSION, 1, int);
	 * FlashVars.configureVar(FlashVarNames.IS_DEMO, true, Boolean);
	 * 
	 * FlashVars.isExternal(FlashVarNames.VERSION);
	 * FlashVars.isSet(FlashVarNames.VERSION);
	 * FlashVars.isEmpty(FlashVarNames.VERSION);
	 * 
	 * FlashVars.getValue(FlashVarNames.LANGUAGE);
	 * </listing>
	 * 
	 *  @includeExample FlashVarsExample.as
	 * 
	 * @author Arjan van Wijk
	 */
	public final class FlashVars
	{
		private static var _flashvars:HashMap;

		/**
		 * Use this in the Main.as to initialize the flashvars.
		 * If you don't use an HTML file, but still want to use the FlashVars class for configuration, use {}
		 * 
		 * @param parameters The parameters object (stage.loaderInfo.parameters)
		 */
		public static function initialize(parameters:Object):void
		{
			FlashVars._flashvars ||= new HashMap("FlashVars");
			
			for (var i:String in parameters)
			{
				FlashVars._flashvars[i] = new FlashVar(i, parameters[i], true);
			}
		}
		
		/**
		 * returns true if the static initialize function is called before
		 */
		public static function isInitialized():Boolean
		{
			return FlashVars._flashvars != null;
		}

		/**
		 * Use this to configure the flashvars with a default value and a type.
		 * 
		 * @param name The flashvar name (use FlashVarNames.NAME)
		 * @param defaultValue The defaultValue if the flashvar is not set or is empty
		 * @param type The class to cast this FlashVar to. Array will use split(','). If null, <code>String</code> is used.
		 * @param enum a class which contains possible values as 'public static const'. If value is not in the enum class, the default will be used.
		 * 
		 * @throws temple.debug.errors.TempleArgumentError When defaultValue is not of type
		 * @throws temple.debug.errors.TempleError When not initialized
		 * 
		 * @example
		 * <listing version="3.0">
		 * FlashVars.configureVar(FlashVarNames.LANGUAGE, 'nl', String);
		 * FlashVars.configureVar(FlashVarNames.VERSION, 1, int);
		 * FlashVars.configureVar(FlashVarNames.IS_DEMO, true, Boolean);
		 * FlashVars.configureVar(FlashVarNames.ALIGN, Align.LEFT, String, Align);
		 * </listing>
		 */
		public static function configureVar(name:String, defaultValue:* = null, type:Class = null, enum:Class = null):void
		{
			if (!FlashVars._flashvars) throwError(new TempleError(FlashVar, 'FlashVars is not initialized yet!'));
			
			var flashVar:FlashVar = FlashVars._flashvars[name];
			
			if (!flashVar) flashVar = FlashVars._flashvars[name] = new FlashVar(name, null);
			
			flashVar.defaultValue = defaultValue;
			flashVar.type = type || String;
			
			// Check enum
			if (enum)
			{
				flashVar._value = Enum.getValue(enum, flashVar._value);
			}
		}

		/**
		 * Checks if the flashvar is external (added via initialize)
		 * 
		 * @param name The flashvar name (use FlashVarNames.NAME)
		 * 
		 * @throws temple.debug.errors.TempleError When not initialized
		 * 
		 * @example
		 * <listing version="3.0">
		 * FlashVars.isExternal(FlashVarNames.LANGUAGE);
		 * </listing>
		 */
		public static function isExternal(name:String):Boolean
		{
			if (!FlashVars._flashvars) throwError(new TempleError(FlashVar, 'FlashVars is not initialized yet!'));
			
			return FlashVars._flashvars[name] && FlashVar(FlashVars._flashvars[name]).external;
		}

		/**
		 * Checks if the flashvar is available in the pool (added via initialize or configureVar)
		 * 
		 * @param name The flashvar name (use FlashVarNames.NAME)
		 * 
		 * @throws temple.debug.errors.TempleError When not initialized
		 * 
		 * @example
		 * <listing version="3.0">
		 * FlashVars.isSet(FlashVarNames.LANGUAGE);
		 * </listing>
		 */
		public static function isSet(name:String):Boolean
		{
			if (!FlashVars._flashvars) throwError(new TempleError(FlashVar, 'FlashVars is not initialized yet!'));
			
			return FlashVars._flashvars[name] != null;
		}

		/**
		 * Checks if the flashvar has a value (null or undefined or "")
		 * 
		 * @param name The flashvar name (use FlashVarNames.NAME)
		 * 
		 * @throws temple.debug.errors.TempleError When not initialized
		 * 
		 * @example
		 * <listing version="3.0">
		 * FlashVars.isEmpty(FlashVarNames.LANGUAGE);
		 * </listing>
		 */
		public static function isEmpty(name:String):Boolean
		{
			if (!FlashVars._flashvars) throwError(new TempleError(FlashVar, 'FlashVars is not initialized yet!'));

			return (FlashVars._flashvars[name] == null || FlashVar(FlashVars._flashvars[name]).value == "" || FlashVar(FlashVars._flashvars[name]).value == undefined);
		}

		/**
		 * Returns the flashvar value.
		 * If the flashvar is empty or not set it will return the defaultValue.
		 * If a class is given it will be casted to that class.
		 * <p>If name is not in the flashvar-pool, a warning is logged and null is returned</p>
		 * 
		 * @param name The flashvar name (use FlashVarNames.NAME)
		 * 
		 * @throws temple.debug.errors.TempleError When not initialized
		 * 
		 * @example
		 * <listing version="3.0">
		 * FlashVars.getValue(FlashVarNames.LANGUAGE);
		 * </listing>
		 */
		public static function getValue(name:String):*
		{
			if (!FlashVars._flashvars) throwError(new TempleError(FlashVar, 'FlashVars is not initialized yet!'));
			
			if (!FlashVars.isSet(name))
			{
				Log.warn('No such flashvar : ' + name, FlashVars);
				return null;
			}
			
			return FlashVar(FlashVars._flashvars[name]).value;
		}
		
		/**
		 * Sets/overwrites the flashvar value
		 * 
		 * @param name The flashvar name (use FlashVarNames.NAME)
		 * @param value The new value
		 * 
		 * @throws temple.debug.errors.TempleError When not initialized
		 * 
		 * @example
		 * <listing version="3.0">
		 * FlashVars.setValue(FlashVarNames.LANGUAGE, 'en');
		 * </listing>
		 */
		public static function setValue(name:String, value:*):void
		{
			if (!FlashVars._flashvars) throwError(new TempleError(FlashVar, 'FlashVars is not initialized yet!'));
			
			if (!FlashVars.isSet(name))
			{
				Log.warn('No such flashvar : ' + name, FlashVars);
			}
			
			FlashVar(FlashVars._flashvars[name]).value = value;
		}

		/**
		 * Returns information about all the flashvars
		 * 
		 * @example
		 * <listing version="3.0">
		 * FlashVars.dump();
		 * 
		 * // output:
		 * //	version : temple.data.FlashVar(name = 'version', default = '1', type = '[class int]', fromHTML = 'true')
		 * //	language : temple.data.FlashVar(name = 'language', default = 'nl', type = '[class String]', fromHTML = 'false')
		 * //	is_demo : temple.data.FlashVar(name = 'is_demo', default = 'true', type = '[class Boolean]', fromHTML = 'false')
		 * </listing>
		 */
		public static function dump():String
		{
			var str:String = 'FlashVars.dump():' + "\n";
			
			for (var name:String in FlashVars._flashvars)
			{
				str += "\t" + name + ': ' + FlashVar(FlashVars._flashvars[name]).value + " \t" + FlashVar(FlashVars._flashvars[name]) + "\n";
			}
			return str;
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(FlashVars);
		}
	}
}