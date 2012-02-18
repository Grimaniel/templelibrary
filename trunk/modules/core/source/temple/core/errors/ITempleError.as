/*
include "../includes/License.as.inc";
 */

package temple.core.errors 
{

	/**
	 * A TempleError extends the 'normal' Error classes with some extra features.
	 * TempleErrors are automatically logged, so it's possible so 'see' the Error even
	 * when you do not have the Flash debug player.
	 * 
	 * TempleErrors also have a reference to the sender (the object that causes the Error)
	 * 
	 * @author Thijs Broerse
	 */
	public interface ITempleError 
	{
		/**
		 * The object that generated the error. If the Error is gererated in a static function sender will be the class.
		 */
		function get sender():Object;
	}
}
