package 
{
	import temple.debug.log.LogLevels;
	import temple.debug.log.Log;
	import temple.utils.types.ObjectUtils;
	
	/**
	 * Creates a log message
	 * 
	 * @author Thijs Broerse
	 */
	public function log(message:*, object:* = "__UNLOGGABLE_STRING__", maxDepth:uint = 1, level:String = "info"):void 
	{
		if (object == "__UNLOGGABLE_STRING__")
		{
			// do nothing
		}
		else if (object == null || object == undefined)
		{
			message += ": " + object;
		}
		else if (object is String || object is Number || object is Boolean || object is uint || object is int)
		{
			message += ": " + ObjectUtils.objectToString(object);
		}
		else
		{
			message += ": " + ObjectUtils.traceObject(object, maxDepth, false);
		}
		
		switch (level)
		{
			case LogLevels.DEBUG:
			{
				Log.debug(message, 'log');
				break;
			}
			case LogLevels.ERROR:
			{
				Log.error(message, 'log');
				break;
			}
			case LogLevels.FATAL:
			{
				Log.fatal(message, 'log');
				break;
			}
			case LogLevels.INFO:
			{
				Log.info(message, 'log');
				break;
			}
			case LogLevels.STATUS:
			{
				Log.status(message, 'log');
				break;
			}
			case LogLevels.WARN:
			{
				Log.warn(message, 'log');
				break;
			}
			default:
			{
				Log.info(message, 'log');
				Log.error("Invalid value for level: '" + level + "'", "log");
			}
		}
	}
}