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
