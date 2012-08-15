/*
include "../includes/License.as.inc";
 */

package temple.core.debug 
{
	import flash.utils.getTimer;
	import temple.core.templelibrary;

	/**
	 * Internal class to store information about an object registration.
	 * 
	 * @author Thijs Broerse
	 */
	internal final class RegistryInfo 
	{
		include "../includes/Version.as.inc";
		
		private static const _TO_STRING_PROPS:Vector.<String> = Vector.<String>(['objectId', 'timestamp']);
		
		private var _stack:String;
		private var _timestamp:int;
		private var _objectId:uint;
	
		public function RegistryInfo(stack:String, objectId:uint) 
		{
			this._timestamp = getTimer();
			this._stack = stack;
			this._objectId = objectId;
		}
	
		public function get stack():String
		{
			return this._stack;
		}
		
		public function get timestamp():int
		{
			return this._timestamp;
		}
		
		public function get objectId():uint
		{
			return this._objectId;
		}
		
		public function toString():String
		{
			return objectToString(this, _TO_STRING_PROPS);
		}
	}
}