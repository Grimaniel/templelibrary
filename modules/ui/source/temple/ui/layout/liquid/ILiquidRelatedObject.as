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

package temple.ui.layout.liquid 
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	/**
	 * Dispatched when the size of the object is changed.
	 * @eventType flash.events.Event.RESIZE
	 */
	[Event(name = "resize", type = "flash.events.Event")]

	/**
	 * An ILiquidRelatedObject can be used by an ILiquidObject as related object. An ILiquidRelatedObject does not need the be liquid (but can be) itself.
	 * <p>An ILiquidRelatedObject dispatches a Event.RESIZE event when his size is changed</p>
	 * 
	 * @includeExample LiquidExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public interface ILiquidRelatedObject extends IEventDispatcher
	{
		/**
		 * Indicates the width of the display object, in pixels. 
		 */
		function get width():Number;
		
		/**
		 * Indicates the horizontal scale (factor) of the object as applied from the registration point. 
		 */
		function get scaleX():Number;
		
		/**
		 * Indicates the minimal width of the object
		 */
		function get minimalWidth():Number;
		
		/**
		 * @private
		 */
		function set minimalWidth(value:Number):void;
		
		/**
		 * Indicates the height of the display object, in pixels.
		 */
		function get height():Number;
		
		/**
		 * Indicates the vertical scale (factor) of the object as applied from the registration point. 
		 */
		function get scaleY():Number;
		
		/**
		 * Indicates the minimal height of the object
		 */
		function get minimalHeight():Number;
		
		/**
		 * @private
		 */
		function set minimalHeight(value:Number):void;
		
		/**
		 * The (parent) object of the liquid object. The LiquidObject is align to its relatedObject. This can also be the Stage trough the LiquidStage 
		 */
		function get relatedObject():ILiquidRelatedObject;
		
		/**
		 * If set to true the objects scale (both X and Y) are set to the opposite of the scale of the related object. So when the parent of this object is also the relatedObject, the scale of the parent can be reset.
		 */
		function get resetRelatedScale():Boolean;

		/**
		 * The inner left top offset of the DisplatOjbect
		 */
		function get offset():Point;
		
		/**
		 * Returns a reference to the corresponting DisplayObject
		 */
		function get displayObject():DisplayObject;
	}
}
