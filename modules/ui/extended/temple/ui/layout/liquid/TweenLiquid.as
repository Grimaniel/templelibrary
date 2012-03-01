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
	import com.greensock.TweenLite;
	/**
	 * Tween class for Liquid objects. TweenLiquid is built on top of TweenLite and makes it possible to 
	 * changes the LiquidProperties of an ILiquidObject in a tween.
	 * 
	 * @see temple.ui.layout.liquid.ILiquidObject
	 * @see temple.ui.layout.liquid.LiquidProperties
	 * 
	 * @author Thijs Broerse
	 */
	public class TweenLiquid 
	{
		/**
		 * Wrapper for TweenLite.to for ILiquidObjects.
		 * Checks if the the ILiquidObject has a value for the LiquidProperties in vars, if not
		 * they will be set first
		 */
		public static function to(target:ILiquidObject, duration:Number, vars:Object):TweenLite
		{
			var property:String;
			var leni:int = LiquidProperties.ALL.length;
			for (var i:int = 0; i < leni; i++)
			{
				property = LiquidProperties.ALL[i];
				if (vars.hasOwnProperty(property))
				{
					if (isNaN(vars[property]))
					{
						target[property] = NaN;
						delete vars[property];
					}
					else if (isNaN(target[property]))
					{
						target[property] = LiquidUtils.calculateProperty(target, property);
					}
				}
			}
			
			if (vars.onUpdate is Function)
			{
				var update:Function = vars.onUpdate as Function;
				vars.onComplete = function():void
				{
					update();
					target.update();
				};
			}
			else
			{
				vars.onUpdate = target.update;
			}
			
			return TweenLite.to(target, duration, vars);
		}
	}
}
