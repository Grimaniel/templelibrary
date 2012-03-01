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
 
package temple.ui.scroll 
{
	import flash.events.IEventDispatcher;

	/**
	 * An IScrollable is an object that can be scrolled (by a ScrollBehavior)
	 * 
	 * @author Thijs Broerse
	 */
	public interface IScrollable extends IEventDispatcher 
	{
		/**
		 * The current horizontal scroll in pixels.
		 */
		function get scrollH():Number;

		/**
		 * @private
		 */
		function set scrollH(value:Number):void;

		/**
		 * The maximal horizontal scroll in pixels
		 */
		function get maxScrollH():Number;
		
		/**
		 * Set the horizontal scroll to a specific value. If there is an IPropertyProxy as scrollProxy this value can be manipulated.
		 */
		function scrollHTo(value:Number):void;
		
		/**
		 * The value set by scrollHTo. Can be different from scrollH if an IPropertyProxy is used as scrollProxy.
		 */
		function get targetScrollH():Number;
		
		/**
		 * The current vertical scroll in pixels.
		 */
		function get scrollV():Number;

		/**
		 * @private
		 */
		function set scrollV(value:Number):void;

		/**
		 * The maximal vertical scroll in pixels
		 */
		function get maxScrollV():Number;
		
		/**
		 * Set the vertical scroll to a specific value. If there is an IPropertyProxy as scrollProxy this value can be manipulated.
		 */
		function scrollVTo(value:Number):void;
		
		/**
		 * The value set by scrollVTo. Can be different from scrollV if an IPropertyProxy is used as scrollProxy.
		 */
		function get targetScrollV():Number
	}
}
