/*
include "../includes/License.as.inc";
 */

package temple.core.errors 
{
	import temple.core.debug.log.Log;
	import temple.core.templelibrary;

	/**
	 * Error thrown when an index is out of range.
	 * The TempleRangeError will automatic Log the error message.
	 * 
	 * @author Thijs Broerse
	 */
	public class TempleRangeError extends RangeError implements ITempleError
	{
		include "../includes/Version.as.inc";
		
		private var _sender:Object;
		
		/**
		 * Creates a new TempleRangeError
		 * @param index the index that is out of range
		 * @param size the size of the range
		 * @param sender The object that gererated the error. If the Error is gererated in a static function, use the toString function of the class
		 * @param message The error message
		 * @param id The id of the error
		 */
		public function TempleRangeError(index:int, size: uint, sender:Object, message:*, id:* = 0)
		{
			this._sender = sender;
			super(message + ' (index=' + index + ', size=' + size + ')', id);
			
			var stack:String = this.getStackTrace();
			if (stack)
			{
				Log.error(stack + " id:" + id, String(sender));
			}
			else
			{
				Log.error("TempleRangeError: '" + message + "' id:" + id, String(sender));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get sender():Object
		{
			return this._sender;
		}
	}
}
