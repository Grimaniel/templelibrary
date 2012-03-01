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
	import temple.core.debug.objectToString;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;
	import temple.utils.types.DisplayObjectUtils;

	import flash.geom.Point;

	/**
	 * @author Thijs Broerse
	 */
	public class LiquidUtils 
	{
		public static function calculateProperty(liquidObject:ILiquidRelatedObject, property:String):Number
		{
			switch (property)
			{
				case LiquidProperties.LEFT:
				{
					return LiquidUtils.getLeft(liquidObject);
					break;
				}
				case LiquidProperties.RIGHT:
				{
					return LiquidUtils.getRight(liquidObject);
					break;
				}
				case LiquidProperties.HORIZONTAL_CENTER:
				{
					return LiquidUtils.getHorizontalCenter(liquidObject);
					break;
				}
				case LiquidProperties.RELATIVE_X:
				{
					return LiquidUtils.getRelativeX(liquidObject);
					break;
				}
				case LiquidProperties.TOP:
				{
					return LiquidUtils.getTop(liquidObject);
					break;
				}
				case LiquidProperties.BOTTOM:
				{
					return LiquidUtils.getBottom(liquidObject);
					break;
				}
				case LiquidProperties.VERTICAL_CENTER:
				{
					return LiquidUtils.getVerticalCenter(liquidObject);
					break;
				}
				case LiquidProperties.RELATIVE_Y:
				{
					return LiquidUtils.getRelativeY(liquidObject);
					break;
				}
			}
			throwError(new TempleArgumentError(LiquidUtils, "Unvalid value for property '" + property + "'"));
			
			return NaN;
		}
		
		/**
		 * Calculates the left property of an ILiquidObject based on his current position
		 */
		public static function getLeft(liquidObject:ILiquidRelatedObject):Number
		{
			if (!liquidObject.displayObject.parent || !(liquidObject as ILiquidRelatedObject).relatedObject) return NaN;
			return DisplayObjectUtils.localToLocal(new Point(liquidObject.displayObject.x, 0), liquidObject.displayObject.parent, (liquidObject as ILiquidRelatedObject).relatedObject.displayObject).x;
		}

		/**
		 * Calculates the right property of an ILiquidObject based on his current position
		 */
		public static function getRight(liquidObject:ILiquidRelatedObject):Number
		{
			if (!liquidObject.displayObject.parent || !(liquidObject as ILiquidRelatedObject).relatedObject) return NaN;
			return (liquidObject as ILiquidRelatedObject).relatedObject.width - liquidObject.displayObject.width - LiquidUtils.getLeft(liquidObject);
		}

		/**
		 * Calculates the horizontalCenter property of an ILiquidObject based on his current position
		 */
		public static function getHorizontalCenter(liquidObject:ILiquidRelatedObject):Number
		{
			if (!liquidObject.displayObject.parent || !(liquidObject as ILiquidRelatedObject).relatedObject) return NaN;
			return (LiquidUtils.getLeft(liquidObject) + LiquidUtils.getRight(liquidObject)) * .5;
		}

		/**
		 * Calculates the relativeX property of an ILiquidObject based on his current position
		 */
		public static function getRelativeX(liquidObject:ILiquidRelatedObject):Number
		{
			if (!liquidObject.displayObject.parent || !(liquidObject as ILiquidRelatedObject).relatedObject) return NaN;
			var left:Number = LiquidUtils.getLeft(liquidObject);
			if (left == 0) return 0;
			var rel:Number = left / ((liquidObject as ILiquidRelatedObject).relatedObject.width - liquidObject.displayObject.width);
			if (isNaN(rel) || rel < 0) return 0;
			if (rel > 1) return 1;
			return rel;
		}

		/**
		 * Calculates the top property of an ILiquidObject based on his current position
		 */
		public static function getTop(liquidObject:ILiquidRelatedObject):Number
		{
			if (!liquidObject.displayObject.parent || !(liquidObject as ILiquidRelatedObject).relatedObject) return NaN;
			return DisplayObjectUtils.localToLocal(new Point(0, liquidObject.displayObject.y), liquidObject.displayObject.parent, (liquidObject as ILiquidRelatedObject).relatedObject.displayObject).y;
		}

		/**
		 * Calculates the bottom property of an ILiquidObject based on his current position
		 */
		public static function getBottom(liquidObject:ILiquidRelatedObject):Number
		{
			if (!liquidObject.displayObject.parent || !(liquidObject as ILiquidRelatedObject).relatedObject) return NaN;
			return (liquidObject as ILiquidRelatedObject).relatedObject.height - liquidObject.displayObject.height - LiquidUtils.getTop(liquidObject);
		}

		/**
		 * Calculates the verticalCenter property of an ILiquidObject based on his current position
		 */
		public static function getVerticalCenter(liquidObject:ILiquidRelatedObject):Number
		{
			if (!liquidObject.displayObject.parent || !(liquidObject as ILiquidRelatedObject).relatedObject) return NaN;
			return (LiquidUtils.getTop(liquidObject) + LiquidUtils.getBottom(liquidObject)) * .5;
		}

		/**
		 * Calculates the relativeY property of an ILiquidObject based on his current position
		 */
		public static function getRelativeY(liquidObject:ILiquidRelatedObject):Number
		{
			if (!liquidObject.displayObject.parent || !(liquidObject as ILiquidRelatedObject).relatedObject) return NaN;
			var top:Number = LiquidUtils.getTop(liquidObject);
			if (top == 0) return 0;
			var rel:Number = top / ((liquidObject as ILiquidRelatedObject).relatedObject.height - liquidObject.displayObject.height);
			if (isNaN(rel) || rel < 0) return 0;
			if (rel > 1) return 1;
			return rel;
		}

		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(LiquidUtils);
		}
	}
}
