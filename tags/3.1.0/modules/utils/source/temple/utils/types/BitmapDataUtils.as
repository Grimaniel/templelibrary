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

package temple.utils.types
{
	import temple.common.enum.Align;
	import temple.common.enum.ScaleMode;
	import temple.core.debug.objectToString;
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
	public final class BitmapDataUtils
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
		
		public static function clear(bitmapData:BitmapData):void
		{
			bitmapData.fillRect(new Rectangle(0, 0, bitmapData.width, bitmapData.height), 0);
		}
		
		public static function rotate(bitmapData:BitmapData, angle:Number):BitmapData
		{
			var matrix:Matrix = new Matrix();
			
			var rotated:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, bitmapData.transparent, 0);

			matrix.translate(bitmapData.width * -.5, bitmapData.height * -.5);
			matrix.rotate(angle * Math.PI / 180);
			matrix.translate(bitmapData.width * .5, bitmapData.height * .5);

			rotated.draw(bitmapData, matrix);
			
			return rotated;
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(BitmapDataUtils);
		}
	}
}
