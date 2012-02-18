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
