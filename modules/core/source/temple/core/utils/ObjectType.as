/*
include "../includes/License.as.inc";
 */

package temple.core.utils 
{
	import temple.core.templelibrary;

	/**
	 * Possible result value when using 'typeof' function on a variable.
	 * 
	 * @author Thijs Broerse
	 */
	public final class ObjectType 
	{
		include "../includes/Version.as.inc";
		
		public static const OBJECT:String = "object";
		
		public static const BOOLEAN:String = "boolean";
		
		public static const NUMBER:String = "number";
		
		public static const STRING:String = "string";

		public static const XML:String = "xml";

		public static const FUNCTION:String = "function";
	}
}
