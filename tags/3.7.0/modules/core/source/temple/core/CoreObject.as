/*
include "../includes/License.as.inc";
 */

package temple.core 
{
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.Destructor;
	import temple.core.templelibrary;

	/**
	 * Base class for all Objects in the Temple. The CoreObject handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * </ul>
	 * 
	 * <p>You should always use and/or extend the CoreObject instead of Object if you want to make use of the Temple features.</p>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @author Thijs Broerse
	 */
	dynamic public class CoreObject extends Object implements ICoreObject
	{
		include "./includes/ConstructNamespace.as.inc";
		
		private const _toStringProps:Vector.<String> = new Vector.<String>();
		private var _isDestructed:Boolean;
		private var _registryId:uint;
		private var _emptyPropsInToString:Boolean = true;

		public function CoreObject()
		{
			construct::coreObject();
		}
		
		/**
		 * @private
		 */
		construct function coreObject():void
		{
			_registryId = Registry.add(this);
		}

		include "./includes/CoreObjectMethods.as.inc";

		include "./includes/LogMethods.as.inc";
		
		include "./includes/ToStringPropsMethods.as.inc";
		
		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			return objectToString(this, toStringProps, !emptyPropsInToString);
		}

		include "./includes/IsDestructed.as.inc";

		/**
		 * @inheritDoc
		 */
		public function destruct():void
		{
			for (var key:String in this)
			{
				Destructor.destruct(this[key]);
				delete this[key];
			}
			_isDestructed = true;
		}
	}
}
