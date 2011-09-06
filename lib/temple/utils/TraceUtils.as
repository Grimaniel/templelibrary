/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.utils 
{
	import temple.debug.objectToString;
	import temple.utils.types.ObjectUtils;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	/**
	 * This utils are only for debugging purposes.
	 * 
	 * @author Thijs Broerse
	 */
	public final class TraceUtils 
	{
		public static const STACK_TRACE_NEWLINE_INDENT:String = "\n   ";
		
		/**
		 * Default properties of every object which are traced in the 'rootTrace' method.
		 * You can change this array if you want to trace more (or less) properties
		 */
		public static const ROOT_TRACE_PROPS:Array = ['name', 'visible', 'alpha', 'mouseEnabled', 'mouseChildren'];
		
		/**
		 * Log the stack trace only for the debugger version of Flash Player and the AIR Debug Launcher (ADL)
		 * 
		 * NOTE: Only use this for debug purpeses!!!
		 */
		public static function stackTrace(doTrace:Boolean = true):String
		{
			var stacktrace:String = new Error("Get stack").getStackTrace();
			
			if (stacktrace == null)
			{
				return null;
			}
			
			var a:Array = stacktrace.split("\n");
			
			var output:String = "Stack:";
			
			var leni:int = a.length;
			for (var i:int = 2;i < leni; i++) 
			{
				output += TraceUtils.STACK_TRACE_NEWLINE_INDENT + String(a[i]).substr(4);
			}
			
			if (doTrace) trace(output);
			
			return output;
		}

		/**
		 * Will do a TraceUtils.rootTrace() on every mouse click.
		 */
		public static function rootTraceOnClick(stage:Stage):void
		{
			stage.addEventListener(MouseEvent.CLICK, TraceUtils.handleStageClick);
		}

		private static function handleStageClick(event:MouseEvent):void
		{
			TraceUtils.rootTrace(event.target as DisplayObject);
		}

		/**
		 * Recursive trace object and his parents
		 * @param object the object to trace
		 * @param doTrace a Boolean which indicates if the result would be trace of only returned
		 * @param props a list of properties which should be traces for every object
		 */
		public static function rootTrace(object:DisplayObject, doTrace:Boolean = true, props:Array = null):String
		{
			var output:String = "Root Trace:\n";
			output += TraceUtils._rootTrace(object, 0, props);
			
			if (doTrace) trace(output);
			
			return output;
		}
		
		private static function _rootTrace(object:DisplayObject, index:int, props:Array):String
		{
			var output:String = "   " + index + ": " + objectToString(object, props || TraceUtils.ROOT_TRACE_PROPS, true);
			
			if (object.parent) output += "\n" + TraceUtils._rootTrace(object.parent, ++index, props);
			
			return output;
		}

		/**
		 * Wrapped function for an ObjectUtils function
		 * 
		 * Recursively traces the properties of an object
		 * @param object object to trace
		 * @param maxDepth indicates the recursive factor
		 * @param doTrace indicates if the function will trace the output or only return it
		 */
		public static function traceObject(object:Object, maxDepth:Number = 3, doTrace:Boolean = true):String
		{
			return ObjectUtils.traceObject(object, maxDepth, doTrace);
		}
		
		public static function doTrace(string:String):void
		{
			trace(string);
		}
	}
}
