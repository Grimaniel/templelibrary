/*
Copyright 2009 Stephan Bezoen, http://stephan.acidcats.nl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

package nl.acidcats.yalog.common 
{
	import temple.core.debug.log.LogLevel;

	public class Levels 
	{
		public static var DEBUG:uint = 0;
		public static var INFO:uint = 1;
		public static var ERROR:uint = 2;
		public static var WARN:uint = 3;
		public static var FATAL:uint = 4;
		public static var STATUS:uint = 5;

		public static var NAMES:Array = [LogLevel.DEBUG, LogLevel.INFO, LogLevel.ERROR, LogLevel.WARN, LogLevel.FATAL, LogLevel.STATUS];
	}
}