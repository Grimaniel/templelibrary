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

package temple.data.xml 
{
	import temple.core.debug.objectToString;

	import flash.events.Event;

	/**
	 * Event class for use with the Service class. Listen to the generic event type to receive these events.
	 * The event has room for both a list of objects as result of a load operation, or a single object.
	 * It is left to the implementation of an extension of Service to determine which of these are used.
	 * 
	 * @author Thijs Broerse
	 */
	public class XMLServiceEvent extends Event 
	{
		/** 
		 * Event sent when loading and parsing is completed
		 */
		public static const COMPLETE:String = "XMLServiceEvent.complete";

		/**
		 * Event sent when all requests have completed; does not check for errors
		 */
		public static const ALL_COMPLETE:String = "XMLServiceEvent.allComplete";

		/**
		 * Event sent when there was an error loading the data
		 */
		public static const LOAD_ERROR:String = "XMLServiceEvent.loadError";

		/**
		 * Event sent when there was an error parsing the data
		 */
		public static const PARSE_ERROR:String = "XMLServiceEvent.parseError";
		
		private static const _TO_STRING_PROPS:Vector.<String> = Vector.<String>(['name', 'type']);

		/** name of original request*/
		public var name:String;
		/** if applicable, a single array of typed data objects */
		public var list:Array;
		/** if applicable, a single object */
		public var object:Object;
		/** if applicable, a string describing the error */
		public var error:String;

		
		public function XMLServiceEvent(type:String, name:String = null, list:Array = null, object:Object = null, error:String = null) 
		{
			super(type);
			
			this.name = name;
			this.list = list;
			this.object = object;
			this.error = error;
		}

		override public function clone():Event 
		{
			return new XMLServiceEvent(this.type, this.name, this.list, this.object, this.error);
		}

		override public function toString():String 
		{
			return objectToString(this, _TO_STRING_PROPS);
		}
	}
}
