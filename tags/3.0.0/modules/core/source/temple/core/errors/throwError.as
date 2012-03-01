/*
include "../includes/License.as.inc";
 */

package temple.core.errors 
{
	import temple.core.Temple;
	import temple.core.debug.log.Log;

	/**
	 * Wrapper function for <code>trow</code>. So it can be disabled by the Temple.
	 * 
	 * <p>Note: When using this, code will continue to run after the call. So maybe you should do a return after this call.</p>
	 * 
	 * @return untyped null
	 * 
	 * @see temple.core.Temple#ignoreErrors
	 * 
	 * @author Thijs Broerse
	 */
	public function throwError(error:Error):*
	{
		if (!(error is ITempleError)) Log.error(error.message + "\n" + error.getStackTrace(), Temple.displayFullPackageInToString ? 'temple.debug.errors.throwError' : 'throwError');
		
		if (!Temple.ignoreErrors)
		{
			throw error;
		}
		return null;
	}
}
