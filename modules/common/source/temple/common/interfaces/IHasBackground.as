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

package temple.common.interfaces 
{
	import temple.core.display.IDisplayObject;
	
	/**
	 * Interface for <code>DisplayObjects</code> which can have a (solid) color filled background.
	 * 
	 * @author Thijs Broerse
	 */
	public interface IHasBackground extends IDisplayObject 
	{
		/**
		 * A Boolean which indicates if background filling is enabled.
		 * If set to true the background of the object will be filled which the color and alpha set by backgroundColor and backgroundAlpha.
		 */
		function get background():Boolean;
		
		/**
		 * @private
		 */
		function set background(value:Boolean):void;
		
		/**
		 * The color of the background of the object, if background is enabled.
		 */
		function get backgroundColor():uint;
		
		/**
		 * @private
		 */
		function set backgroundColor(value:uint):void;
		
		/**
		 * The Number (between 0 and 1) which indicates the alpha of the background of the object, if background is enabled.
		 */
		function get backgroundAlpha():Number;
		
		/**
		 * @private
		 */
		function set backgroundAlpha(value:Number):void;
	}
}
