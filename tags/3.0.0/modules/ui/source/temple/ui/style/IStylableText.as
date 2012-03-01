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

package temple.ui.style 
{

	/**
	 * This class add some extra CSS property which can normally not be applied by CSS. Implementation is done by code.
	 * 
	 * @author Thijs Broerse
	 */
	public interface IStylableText 
	{
		/**
		 * The text-transform property controls the capitalization of text.
		 * See TextTransform class for possible values
		 */
		function get textTransform():String;

		/**
		 * @private
		 */
		function set textTransform(value:String):void;
		
		/**
		 * Anti-alias type for text rendering. Possible values are AntiAlias.ANIMATION or AntiAlias.READABILITY.
		 */
		function get antiAlias():String;
		
		/**
		 * @private
		 */
		function set antiAlias(value:String):void;
		
		/**
		 * Indicates whether the text field is a multiline text field. If the value is true, the text field is multiline; if the value is false, the text field is a single-line text field. 
		 */
		function get multiline():Boolean;
		
		/**
		 * @private
		 */
		function set multiline(value:Boolean):void;
	}
}