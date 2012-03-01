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
	/**
	 * A liquid object is an object witch positon (x and y) and dimension (width and height) is influenced by his 'parent' (related object)
	 * <p>Instead of just setting an objects x and y, you can set the objects left, right, top and/or bottom. The actual position will depand and the related object</p>
	 * <p>If you do not set the objects related object it will search in parent list (display list) for an ILiquidRelatedObject. If no ILiquidRelatedObject is found the stage will be used as related object.</p>  
	 * 
	 * @includeExample LiquidExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public interface ILiquidObject extends ILiquidRelatedObject
	{
		/**
		 * The left offset of the liquid object in pixels.
		 */
		function get left():Number;
		
		/**
		 * @private
		 */
		function set left(value:Number):void;
		
		/**
		 * The right offset of the liquid object in pixels.
		 */
		function get right():Number;
		
		/**
		 * @private
		 */
		function set right(value:Number):void;
		
		/**
		 * The horizontal offset of the liquid object in pixels, where 0 means centered, and -10 means 10 pixels to the left of the center.
		 */
		function get horizontalCenter():Number;
		
		/**
		 * @private
		 */
		function set horizontalCenter(value:Number):void;
		
		/**
		 * The relative horizontal position as a factor. Where 0 means to the left, .5 in the center and 1 to the right.
		 * Value can not be lower then 0 or greater than 1 
		 */
		function get relativeX():Number;
		
		/**
		 * @private
		 */
		function set relativeX(value:Number):void;
		
		/**
		 * Value between 0 and 1. E.g. a value of 0.5 means the halve of his relatedObject width.
		 */
		function get relativeWidth():Number;

		/**
		 * @private
		 */
		function set relativeWidth(value:Number):void;

		/**
		 * Overwrites the 'width' of the target.
		 */
		function get absoluteWidth():Number;

		/**
		 * @private
		 */
		function set absoluteWidth(value:Number):void;
		
		/**
		 * The offset to the top of the liquid object in pixels.
		 */
		function get top():Number;
		
		/**
		 * @private
		 */
		function set top(value:Number):void;
		
		/**
		 * The offset to the bottom of the liquid object in pixels.
		 */
		function get bottom():Number;
		
		/**
		 * @private
		 */
		function set bottom(value:Number):void;
		
		/**
		 * The vertical offset of the liquid object in pixels, where 0 means centered, and -10 means 10 pixels to the top of the center.
		 */
		function get verticalCenter():Number;
		
		/**
		 * @private
		 */
		function set verticalCenter(value:Number):void;
		
		/**
		 * The relative vertical position as a factor. Where 0 means to the top, .5 in the middle and 1 to the bottom.
		 * Value can not be lower then 0 and greater than 1 
		 */
		function get relativeY():Number;
		
		/**
		 * @private
		 */
		function set relativeY(value:Number):void;
		
		/**
		 * If the value is between 0 and 1, it is handled as relative. E.g. a value of 0.5 means the halve of his relatedObject height.
		 */
		function get relativeHeight():Number;
		
		/**
		 * @private
		 */
		function set relativeHeight(value:Number):void;
		
		/**
		 * Overwrites the 'width' of the target.
		 */
		function get absoluteHeight():Number;

		/**
		 * @private
		 */
		function set absoluteHeight(value:Number):void;

		/**
		 * @private
		 */
		function set relatedObject(value:ILiquidRelatedObject):void;

		/**
		 * Updates the LiquidObject
		 */
		function update():void;

		/**
		 * Indicates if one (or more) of the Liquid properties (left, right, top, bottom, horizontalCenter or verticalCenter) is set and Liquid is active.
		 */
		function isLiquid():Boolean;

		/**
		 * @private
		 */
		function set resetRelatedScale(value:Boolean):void;

		/**
		 * If set to tro the LiquidBehavior will try to keep the aspect ratio of the object
		 */
		function get keepAspectRatio():Boolean;

		/**
		 * @private
		 */
		function set keepAspectRatio(value:Boolean):void;

		/**
		 * Indicates if the related objects minimalWidth and minimalHeight should be updates. Default: true
		 * Note: If the related object is not the LiquidStage setting this value to false can cause weird errors
		 */
		function get adjustRelated():Boolean;

		/**
		 * @private
		 */
		function set adjustRelated(value:Boolean):void;
	}
}
