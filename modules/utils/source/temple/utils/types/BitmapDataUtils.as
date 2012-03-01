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

package temple.utils.types
{
	import temple.common.enum.Align;
	import temple.common.enum.ScaleMode;
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.throwError;

	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * This class contains some functions for handling BitmapData.
	 * 
	 * @author Arjan van Wijk
	 */
	public class BitmapDataUtils
	{
		public static function crop(bitmapData:BitmapData, rect:Rectangle, align:String = 'center', scaleMode:String = 'noScale'):BitmapData
		{
			var bmd:BitmapData = new BitmapData(rect.width, rect.height);
			
			// calculate scale ratios
			var ratioX:Number = rect.width / bitmapData.width;
			var ratioY:Number = rect.height / bitmapData.height;
			var scale:Number;
			var translate:Point = new Point();
			
			var matrix:Matrix = new Matrix();
			
			// scale
			switch (scaleMode)
			{
				case ScaleMode.EXACT_FIT:
				{
					matrix.scale(ratioX, ratioY);
					break;
				}
				case ScaleMode.SHOW_ALL:
				{
					scale = ratioX < ratioY ? ratioX : ratioY;
					matrix.scale(scale, scale);
					break;
				}
				case ScaleMode.NO_BORDER:
				{
					scale = ratioX > ratioY ? ratioX : ratioY;
					matrix.scale(scale, scale);
					break;
				}
			}
			
			// align
			if (scaleMode != ScaleMode.EXACT_FIT)
			{
				// align horizontal
				switch (align)
				{
					case Align.TOP_LEFT:
					case Align.LEFT:
					case Align.BOTTOM_LEFT:
					{
						// do nothing
						break;
					}
					case Align.TOP_RIGHT:
					case Align.RIGHT:
					case Align.BOTTOM_RIGHT:
					{
						translate.x = (rect.width - (bitmapData.width * matrix.a));
						break;
					}
					case Align.TOP:
					case Align.BOTTOM:
					default:
					{
						translate.x = (rect.width - (bitmapData.width * matrix.a)) / 2;
						break;
					}
				}
				
				// align vertical
				switch (align)
				{
					case Align.TOP_LEFT:
					case Align.TOP:
					case Align.TOP_RIGHT:
					{
						// do nothing
						break;
					}
					case Align.BOTTOM_LEFT:
					case Align.BOTTOM:
					case Align.BOTTOM_RIGHT:
					{
						translate.y = (rect.height - (bitmapData.height * matrix.d));
						break;
					}
					case Align.LEFT:
					case Align.RIGHT:
					default:
					{
						translate.y = (rect.height - (bitmapData.height * matrix.d)) / 2;
						break;
					}
				}
			}
			
			matrix.translate(translate.x, translate.y);
			
			bmd.draw(bitmapData, matrix, null, null, null, true);
			
			return bmd;
		}
		
		public static function getScaledBitmap(target:BitmapData, scaleX:Number, scaleY:Number, smooth:Boolean=true):BitmapData
		{
			if(!target) throwError(new TempleArgumentError(BitmapDataUtils, 'null or empty target'));
			if(isNaN(scaleX)) throwError(new TempleArgumentError(BitmapDataUtils, 'NaN scaleX'));
			if(isNaN(scaleY)) throwError(new TempleArgumentError(BitmapDataUtils, 'NaN scaleY'));
			
			var width:int = Math.round(target.width * scaleX);
			var height:int = Math.round(target.height * scaleY);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			
			var bitmap:BitmapData = new BitmapData(width, height, target.transparent, 0x00000000);
			bitmap.draw(target, matrix, null, null, null, smooth);
			return bitmap;
		}
		
		public static function opaqueBitmap(source:BitmapData, color:uint=0x0):BitmapData
		{
			if(!source) throwError(new TempleArgumentError(BitmapDataUtils, 'null or empty source'));
			
			if(!source.transparent)
			{
				return source;
			}
			
			var bitmap:BitmapData = new BitmapData(source.width, source.height, false, color);
			bitmap.draw(source, null, null, null, null, true);
			return bitmap;
		}
		
		public static function applyFilters(target:BitmapData, filters:Array):void
		{
			if(!target) throwError(new TempleArgumentError(BitmapDataUtils, 'null or empty target'));
			if(!filters) throwError(new TempleArgumentError(BitmapDataUtils, 'null or empty filters'));
			
			var zero:Point = new Point();
			for each(var filter:BitmapFilter in filters)
			{
				target.applyFilter(target, target.rect, zero, filter);
			}
		}
	}
}
