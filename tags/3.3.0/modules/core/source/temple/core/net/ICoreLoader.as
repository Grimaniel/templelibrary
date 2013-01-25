/*
include "../includes/License.as.inc";
 */

package temple.core.net 
{
	import temple.core.ICoreObject;
	import temple.core.events.ICoreEventDispatcher;

	/**
	 * Implemented by all core-loader objects like CoreNetStream, CoreURLLoader, CoreURLStream and CoreLoader.
	 * <p>ICoreLoader add some basic properies to the loader like the url. ICoreLoader objects listens to error-events and can log error when those occur. Since ICoreLoaders listen to there own ErrorEvent "unhandle ErrorEvents"-errors won't occur.</p>
	 * 
	 * @author Thijs Broerse
	 */
	public interface ICoreLoader extends ILoader, ICoreEventDispatcher, ICoreObject
	{
		/**
		 * The URL that is currently loaded or being loaded
		 */
		function get url():String
		
		/**
		 * If set to true an error message wil be logged on an Error (IOError or SecurityError).
		 * <p>Error events are always handled by the loader so an "unhandle ErrorEvents"-errors won't occur.</p>
		 */
		function get logErrors():Boolean
		
		/**
		 * @private
		 */
		function set logErrors(value:Boolean):void
	}
}
