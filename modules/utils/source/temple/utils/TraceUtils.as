/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.utils 
{
	import temple.core.debug.objectToString;
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
		public static const ROOT_TRACE_PROPS:Vector.<String> = Vector.<String>(['name', 'visible', 'alpha', 'mouseEnabled', 'mouseChildren']);
		
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
		public static function rootTrace(object:DisplayObject, doTrace:Boolean = true, props:Vector.<String> = null):String
		{
			var output:String = "Root Trace:\n";
			output += TraceUtils._rootTrace(object, 0, props);
			
			if (doTrace) trace(output);
			
			return output;
		}
		
		private static function _rootTrace(object:DisplayObject, index:int, props:Vector.<String>):String
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
