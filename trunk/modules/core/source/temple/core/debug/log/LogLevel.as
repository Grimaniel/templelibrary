/*
include "../includes/License.as.inc";
 */

package temple.core.debug.log 
{
	/**
	 * This class contains all possible levels of log messages.
	 * 
	 * @author Thijs Broerse
	 */
	public final class LogLevel 
	{
		/**
		 * The information is only useful when debugging the application.
		 */
		public static const DEBUG:String = "debug";
		
		/**
		 * Just some information. Everything is OK. 
		 */
		public static const INFO:String = "info";
		
		/**
		 * Something is not OK, but we can still continue.
		 */
		public static const WARN:String = "warn";
		
		/**
		 * Something went wrong, you should check it.
		 */
		public static const ERROR:String = "error";
		
		/**
		 * Something went terribly wrong, you should quit immediately.
		 */
		public static const FATAL:String = "fatal";
		
		/**
		 * Internal used level.
		 */
		public static const STATUS:String = "status";
	}
}
