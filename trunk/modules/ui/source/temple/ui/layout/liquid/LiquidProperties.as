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
	 * Constants class for all properties of ILiquidObject
	 * 
	 * @see temple.ui.layout.liquid.ILiquidObject
	 * 
	 * @author Thijs Broerse
	 */
	public class LiquidProperties 
	{
		/**
		 * The left offset of the liquid object in pixels.
		 * 
		 * @see temple.ui.layout.liquid.ILiquidObject#left
		 */
		public static const LEFT:String = "left";
		
		/**
		 * The right offset of the liquid object in pixels.
		 * 
		 * @see temple.ui.layout.liquid.ILiquidObject#right
		 */
		public static const RIGHT:String = "right";
		
		/**
		 * The horizontal offset of the liquid object in pixels, where 0 means centered, and -10 means 10 pixels to the left of the center.
		 * 
		 * @see temple.ui.layout.liquid.ILiquidObject#horizontalCenter
		 */
		public static const HORIZONTAL_CENTER:String = "horizontalCenter";
		
		/**
		 * The relative horizontal position as a factor. Where 0 means to the left, .5 in the center and 1 to the right.
		 * Value can not be lower then 0 and greater than 1
		 * 
		 * @see temple.ui.layout.liquid.ILiquidObject#relativeX
		 */
		public static const RELATIVE_X:String = "relativeX";
		
		/**
		 * The offset to the top of the liquid object in pixels.
		 * 
		 * @see temple.ui.layout.liquid.ILiquidObject#top
		 */
		public static const TOP:String = "top";

		/**
		 * The offset to the bottom of the liquid object in pixels.
		 * 
		 * @see temple.ui.layout.liquid.ILiquidObject#bottom
		 */
		public static const BOTTOM:String = "bottom";

		/**
		 * The vertical offset of the liquid object in pixels, where 0 means centered, and -10 means 10 pixels to the top of the center.
		 * 
		 * @see temple.ui.layout.liquid.ILiquidObject#verticalCenter
		 */
		public static const VERTICAL_CENTER:String = "verticalCenter";

		/**
		 * The relative vertical position as a factor. Where 0 means to the top, .5 in the middle and 1 to the bottom.
		 * Value can not be lower then 0 and greater than 1
		 * 
		 * @see temple.ui.layout.liquid.ILiquidObject#relativeY
		 */
		public static const RELATIVE_Y:String = "relativeY";

		/**
		 * List of all LiquidProperties
		 */
		public static const ALL:Array = [LiquidProperties.LEFT
										,LiquidProperties.RIGHT
										,LiquidProperties.HORIZONTAL_CENTER
										,LiquidProperties.RELATIVE_X
										,LiquidProperties.TOP
										,LiquidProperties.BOTTOM
										,LiquidProperties.VERTICAL_CENTER
										,LiquidProperties.RELATIVE_Y];
	}
}