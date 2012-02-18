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

package temple.data.result 
{
	import temple.common.interfaces.IResult;
	import temple.core.CoreObject;

	/**
	 * Result object with information about a call.
	 * 
	 * <p>Result objects are passed as argument for a callback method.</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class Result extends CoreObject implements IResult 
	{
		protected var _success:Boolean;
		protected var _message:String;
		protected var _code:String;

		public function Result(success:Boolean = false, message:String = null, code:String = null)
		{
			this._success = success;
			this._message = message;
			this._code = code;
			
			this.toStringProps.push('success', 'message', 'code');
			this.emptyPropsInToString = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get success():Boolean
		{
			return this._success;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get message():String
		{
			return this._message;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get code():String
		{
			return this._code;
		}
	}
}
