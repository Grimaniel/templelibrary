/*
include "../includes/License.as.inc";
 */

package temple.core.display
{
	import temple.core.debug.IDebuggable;
	/**
	 * @author Thijs Broerse
	 */
	public interface ICoreMovieClip extends IMovieClip, ICoreDisplayObjectContainer, IDebuggable
	{
		/**
		 * A Boolean which indicates if the MovieClip has a script on a specific frame.
		 * @param frame the frame to check for a script. Note: frame is 1 based.
		 */
		function hasFrameScript(frame:uint):Boolean;

		/**
		 * A Boolean which indicates if the MovieClip has frame scripts.
		 */
		function get hasFrameScripts():Boolean;
		
		/**
		 * Returns the script in a specific frame.
		 * @param frame the frame which has the script. Note: frame is 1 based.
		 */
		function getFrameScript(frame:uint):Function;

		/**
		 * Set the script on a specific frame.
		 * @param frame the frame of the script. Note: frame is 1 based.
		 * @param script the script to set on the frame.
		 */
		function setFrameScript(frame:uint, script:Function):void;

		/**
		 * Clears the script on a specific frame.
		 * @param frame the frame to clear. Note: frame is 1 based.
		 */
		function clearFrameScript(frame:uint):void
		
		/**
		 * Removes all frame scripts.
		 */
		function clearFrameScripts():void
	}
}
