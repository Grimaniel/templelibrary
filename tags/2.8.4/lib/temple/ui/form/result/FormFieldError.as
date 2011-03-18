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

package temple.ui.form.result 
{
	import temple.debug.getClassName;
	import temple.data.xml.IXMLParsable;
	import temple.data.result.Result;

	/**
	 * @author Thijs Broerse
	 */
	public class FormFieldError extends Result implements IFormFieldError, IXMLParsable 
	{
		protected var _field:String;

		public function FormFieldError(field:String = null, message:String = null, code:String = null)
		{
			super(false, message, code);
			
			this._field = field;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function parseXML(xml:XML):Boolean
		{
			this._field = xml.@field;
			this._code = xml.@code;
			this._message = xml;
			
			return true;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get field():String
		{
			return this._field;
		}

		/**
		 * @inheritDoc 
		 */
		override public function toString():String
		{
			return getClassName(this) + ": " + this._field + (this.message != null ? ", message='" + this.message + "'" : "") + (this.code ? ", code=" + this.code : "");
		}
	}
}
