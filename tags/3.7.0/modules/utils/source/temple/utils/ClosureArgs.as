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
	import temple.common.interfaces.IExecutable;
	import temple.core.CoreObject;

	/**
	 * ClosureArgs
	 * AS3-style DelegateArgs: useful to pass parameters to a callback when you can't.
	 * 		
	 * @example
	 * <listing version="3.0">	
	 * myAction.callback = ClosureArgs.create(someObject.method, [1, 2, 3]);
	 * </listing>
	 * 	
	 * you also could keep an instance for re-use (with destructAfterCall = false)
	 * 
	 * @example
	 * <listing version="3.0">		
	 * var ca:ClosureArgs = new ClosureArgs(someObject.handler, [1, 2, 3], false);
	 * myAction.callback = ca;
	 * </listing>
	 * 			
	 * Don't forget ca.destruct() to kill references!
	 *
	 * @author Bart van der Schoor
	 */
	public class ClosureArgs extends CoreObject implements IExecutable
	{
		/**
		 * Creates a function reference to the ClosureArgs
		 * @param method the method to be calles
		 * @param arguments the arguments to be passed to the method
		 * @param destructAfterCall if set to true, to ClosureArgs is destructed after the call.
		 */
		public static function create(method:Function, arguments:Array = null, destructAfterCall:Boolean = false):Function
		{
			return new ClosureArgs(method, arguments, destructAfterCall).execute;	
		}
		
		private var _method:Function;
		private var _arguments:Array;		private var _destructAfterCall:Boolean;

		/**
		 * Creates a new ClosureArgs
		 * @param method the method to be called
		 * @param arguments the arguments to be passed to the method
		 * @param destructAfterCall if set to true, to ClosureArgs is destructed after the call.
		 */
		public function ClosureArgs(method:Function, arguments:Array = null, destructAfterCall:Boolean = false)
		{
			_method = method;
			_arguments = arguments;			_destructAfterCall = destructAfterCall;
		}

		/**
		 * Calls the ClosureArgs. The method is called with the provided arguments. 
		 */
		public function execute():void
		{
			if (_method != null)
			{
				if (_arguments != null)
				{
					_method.apply(null, _arguments);
				}
				else
				{
					_method();
				}
				if (_destructAfterCall)
				{
					destruct();
				}
			}
			else
			{
				destruct();
			}	
		}

		/**
		 * Indicates if the ClosureArgs should be destructed after call
		 */
		public function get destructAfterCall():Boolean
		{
			return _destructAfterCall;
		}

		/**
		 * @private
		 */
		public function set destructAfterCall(value:Boolean):void
		{
			_destructAfterCall = value;
		}
		
		/**
		 * Returns a reference to the method 
		 */
		public function get method():Function
		{
			return _method;
		}
		
		/**
		 * Returns a reference to the arguments
		 */
		public function get arguments():Array
		{
			return _arguments;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			_method = null; 
			_arguments = null;
			
			super.destruct(); 	
		}
	}
}
