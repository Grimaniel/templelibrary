/*
include "../includes/License.as.inc";
 */

package temple.core.destruction 
{
	import temple.core.CoreObject;
	import temple.core.templelibrary;

	import flash.utils.Dictionary;

	/**
	 * The DestructController us used to destruct multiple objects at once.
	 * 
	 * <p>Add objects to the DestructController, call destructAll() to destruct all objects.
	 * Objects are stored using a weak-reference, so the DestructController will not block
	 * objects for garbage collection.</p>
	 * 
	 * @author Bart van der Schoor, Thijs Broerse
	 */
	public class DestructController extends CoreObject
	{
		include "../includes/Version.as.inc";
		
		protected static var _instance:DestructController;

		private var _list:Dictionary;
		private var _debug:Boolean = false;

		/**
		 * Creates a new DestructController
		 */
		public function DestructController()
		{
			this._list = new Dictionary(true);
		}

		/**
		 * Add an object to the DestructController for later destruction.
		 */
		public function add(object:Object):void
		{
			this._list[object] = true;
			if (this._debug) this.logDebug("Add " + object);
		}

		/**
		 * Destruct all objects of the DestructController
		 */
		public function destructAll():void
		{
			for (var object:Object in this._list) 
			{
				if (this._debug) this.logDebug("Destruct " + object);
				Destructor.destruct(object);
				delete this._list[object];
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}

		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._list)
			{
				this.destructAll();
				this._list = null;
			}
			super.destruct();
		}
	}
}