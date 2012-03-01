/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
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
			this._method = method;
			this._arguments = arguments;			this._destructAfterCall = destructAfterCall;
		}

		/**
		 * Calls the ClosureArgs. The method is called with the provided arguments. 
		 */
		public function execute():void
		{
			if (this._method != null)
			{
				if (this._arguments != null)
				{
					this._method.apply(null, this._arguments);
				}
				else
				{
					this._method();
				}
				if (this._destructAfterCall == true)
				{
					this.destruct();
				}
			}
			else
			{
				this.destruct();
			}	
		}

		/**
		 * Indicates if the ClosureArgs should be destructed after call
		 */
		public function get destructAfterCall():Boolean
		{
			return this._destructAfterCall;
		}

		/**
		 * @private
		 */
		public function set destructAfterCall(value:Boolean):void
		{
			this._destructAfterCall = value;
		}
		
		/**
		 * Returns a reference to the method 
		 */
		public function get method():Function
		{
			return this._method;
		}
		
		/**
		 * Returns a reference to the arguments
		 */
		public function get arguments():Array
		{
			return this._arguments;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._method = null; 
			this._arguments = null;
			
			super.destruct(); 	
		}
	}
}
