/*
include "../includes/License.as.inc";
 */

package temple.core.net 
{

	/**
	 * Interface for all objects that can load something.
	 * 
	 * @author Thijs Broerse
	 */
	public interface ILoader 
	{
		/**
		 * Returns true if Loader is currently loading
		 */
		function get isLoading():Boolean
		
		/**
		 * Returns true if Loader has succesfully completed the loading
		 */
		function get isLoaded():Boolean
	}
}
