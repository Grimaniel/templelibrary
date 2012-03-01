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
