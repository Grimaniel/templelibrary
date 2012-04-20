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

package temple.core 
{
	import temple.core.debug.DebugMode;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.objectToString;

	/**
	 * This class contains information about the Temple Library and some global properties and settings.
	 * 
	 * <p>Note: This class contains only static properties. Therefore this class cannot be instantiated.</p>
	 * 
	 * @includeExample ../templates/DocumentClassExample.as
	 * 
	 * @author MediaMonks: Thijs Broerse, Arjan van Wijk, Quinten Beek, Bart van der Schoor
	 */
	public final class Temple 
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.2";
		
		/**
		 * The name of the Temple.
		 */
		public static const NAME:String = "Temple";
		
		/**
		 * The current version of the Temple Library.
		 */
		public static const VERSION:String = "3.0.2";
		
		/**
		 * The Authors of the Temple.
		 */
		public static const AUTHOR:String = "MediaMonks: Thijs Broerse, Arjan van Wijk, Quinten Beek, Bart van der Schoor, Stephan Bezoen";
		
		/**
		 * Last modified date of the Temple.
		 * (Format: 'yyyy-mm-dd')
		 * 
		 */
		public static const DATE:String = "2012-04-18";

		/**
		 * The official website of the Temple.
		 * <a href="http://code.google.com/p/templelibrary/" target="_blank">http://code.google.com/p/templelibrary/</a>
		 */
		public static const WEBSITE:String = "http://code.google.com/p/templelibrary/";
		
		/**
		 * When set to true, all Temple objects are registered in the <code>Memory</code> class with a weak reference.
		 * Useful for debugging to track all existing objects.
		 * After destructing an object (and force a Garbage Collection) the object should no longer exist.
		 * 
		 * Note: Changing this value must be done here or before the <code>super()</code> inside the constructor of your
		 * application root.
		 * 
		 * @see temple.core.debug.Registry
		 * @see temple.core.debug.Memory
		 */
		public static var registerObjectsInMemory:Boolean = true;

		/**
		 * When set to true and <code>registerObjectsInMemory</code> is set to true, all Temple objects are registered 
		 * with the call stack info. This can be useful for debugging.
		 * 
		 * Note: Changing this value must be done here or before the <code>super()</code> inside the constructor of your
		 * application root.
		 * 
		 * @see temple.core.debug.Registry
		 * @see temple.core.debug.Memory
		 */
		public static var registerObjectsWithStack:Boolean = false;
		
		/**
		 * When debug is not set in the URL, this debugmode is used for the DebugManager.
		 * Possible values are:
		 * <table class="innertable">
		 * 	<tr>
		 * 		<th>DebugMode Constant</th>
		 * 		<th>Description</th>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.NONE</td>
		 * 		<td>Debug will be set to false on all debuggable objects. So no debug messages will be logged.</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.CUSTOM</td>
		 * 		<td>Debug can be set to each debuggable object individually.</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.ALL</td>
		 * 		<td>Debug will be set to true on all debuggable objects. So debug messages will be logged</td>
		 * 	</tr>
		 * </table>
		 * 
		 * @see temple.core.debug.DebugManager
		 * @see temple.core.debug.DebugMode
		 */
		public static var defaultDebugMode:String = DebugMode.CUSTOM;

		/**
		 * Indicates if Temple errors should be ignored. If set to true, Temple errors are still logged, but not thrown.
		 * 
		 * @see temple.core.errors#throwError()
		 */
		public static var ignoreErrors:Boolean = false;
		
		/**
		 * Indicates if the package will be displayed when calling a toString() method on an object or class
		 * Example:
		 * If set to true trace(Temple) will output 'temple.core.Temple'
		 * If set to false trace(Temple) will output 'Temple'
		 * 
		 * @see temple.core.debug.getClassName#getClassName()
		 */
		public static var displayFullPackageInToString:Boolean = false;
		
		private static const _TO_STRING_PROPS:Vector.<String> = Vector.<String>(['registerObjectsInMemory', 'defaultDebugMode', 'ignoreErrors']);
		
		/**
		 * Destructs all objects of the Temple. Useful when unloading an ApplicationDomainRoot object.
		 */
		public static function destruct():void
		{
			Log.warn(Temple, "All objects of the Temple are being destructed");
			Registry.destructAll();
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(Temple, Temple._TO_STRING_PROPS);
		}
	}
}
