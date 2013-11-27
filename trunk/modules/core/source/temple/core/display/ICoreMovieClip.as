/*
include "../includes/License.as.inc";
 */

package temple.core.display
{
	import temple.core.debug.IDebuggable;
	
	import flash.display.FrameLabel;
	
	/**
	 * @author Thijs Broerse
	 */
	public interface ICoreMovieClip extends IMovieClip, ICoreDisplayObjectContainer, IDebuggable
	{
		/**
		 * A Boolean which indicates if the MovieClip has a script on a specific frame.
		 * @param frame the frame to check for a script. Note: frame is 1 based.
		 */
		function hasFrameScript(frame:Object):Boolean;

		/**
		 * A Boolean which indicates if the MovieClip has frame scripts.
		 */
		function get hasFrameScripts():Boolean;
		
		/**
		 * Returns the script in a specific frame.
		 * @param frame the frame which has the script. Note: frame is 1 based.
		 */
		function getFrameScript(frame:Object):Function;

		/**
		 * Set the script on a specific frame.
		 * @param frame the frame of the script. Note: frame is 1 based.
		 * @param script the script to set on the frame.
		 */
		function setFrameScript(frame:Object, script:Function):void;

		/**
		 * Clears the script on a specific frame.
		 * @param frame the frame to clear. Note: frame is 1 based.
		 */
		function clearFrameScript(frame:Object):void;
		
		/**
		 * Removes all frame scripts.
		 */
		function clearFrameScripts():void;
		
		/**
		 * Returns a hash with all the FrameLabels with the name and frame as index.
		 */
		function get frameLabels():Object;
		
		/**
		 * Returns the FrameLabel for a specific frame.
		 */
		function getFrameLabel(frame:Object):FrameLabel;
		
		/**
		 * Returns the frame for a specific frame number or frame label. Returns 0 if the frame is not found
		 */
		function getFrame(frame:Object):int;
		
		/**
		 * Returns <code>true</code> if the timeline contains a specific frame label.
		 */
		function hasFrameLabel(frame:Object):Boolean;
	}
}
