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
	import temple.core.debug.objectToString;

	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * This class contains some functions for the Stage.
	 * 
	 * @author Thijs Broerse
	 */
	public final class StageUtils 
	{
		private static var _buildWidth:Number;
		private static var _buildHeight:Number;

		/**
		 * Returns the position and size of the stage in the SWF 
		 */
		public static function getRect(stage:Stage):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			
			stage.addEventListener(Event.RESIZE, handleStageResize, true, int.MAX_VALUE, true);
			
			rect.width = stage.stageWidth;
			rect.height = stage.stageHeight;
			
			if (stage.scaleMode == StageScaleMode.NO_SCALE)
			{
				switch (stage.align)
				{
					case "":
					case StageAlign.TOP:
					case StageAlign.BOTTOM:
					{
						rect.x = .5 * (getBuildWidth(stage) - stage.stageWidth);
						break;
					}
					case StageAlign.RIGHT:
					case StageAlign.TOP_RIGHT:
					case StageAlign.BOTTOM_RIGHT:
					{
						rect.x = getBuildWidth(stage) - stage.stageWidth;
						break;
					}
				}
				switch (stage.align)
				{
					case "":
					case StageAlign.LEFT:
					case StageAlign.RIGHT:
					{
						rect.y = .5 * (getBuildHeight(stage) - stage.stageHeight);
						break;
					}
					case StageAlign.BOTTOM:
					case StageAlign.BOTTOM_LEFT:
					case StageAlign.BOTTOM_RIGHT:
					{
						rect.y = (getBuildHeight(stage) - stage.stageHeight);
						break;
					}
				}
			}
			
			if (stage.scaleMode == StageScaleMode.NO_BORDER || stage.scaleMode == StageScaleMode.SHOW_ALL)
			{
				var originalRatio:Number = stage.stageWidth / stage.stageHeight;
				 
				var scaleMode:String = stage.scaleMode;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				var currentRatio:Number = stage.stageWidth / stage.stageHeight;
				stage.scaleMode = scaleMode;
				
				if (currentRatio > originalRatio)
				{
					// wider
					if (scaleMode == StageScaleMode.SHOW_ALL)
					{
						rect.width = stage.stageHeight * currentRatio;
						
						switch (stage.align)
						{
							case "":
							case StageAlign.TOP:
							case StageAlign.BOTTOM:
							{
								rect.x = .5 * (stage.stageWidth - rect.width);
								break;
							}
							case StageAlign.RIGHT:
							case StageAlign.TOP_RIGHT:
							case StageAlign.BOTTOM_RIGHT:
							{
								rect.x = stage.stageWidth - rect.width;
								break;
							}
						}
					}
					else
					{
						rect.height = stage.stageWidth / currentRatio;
						
						switch (stage.align)
						{
							case "":
							case StageAlign.LEFT:
							case StageAlign.RIGHT:
							{
								rect.y = .5 * (stage.stageHeight - rect.height);
								break;
							}
							case StageAlign.BOTTOM:
							case StageAlign.BOTTOM_LEFT:
							case StageAlign.BOTTOM_RIGHT:
							{
								rect.y = stage.stageHeight - rect.height;
								break;
							}
						}
					}
				}
				else
				{
					// higher
					if (scaleMode == StageScaleMode.SHOW_ALL)
					{
						rect.height = stage.stageWidth / currentRatio;
						
						switch (stage.align)
						{
							case "":
							case StageAlign.LEFT:
							case StageAlign.RIGHT:
							{
								rect.y = .5 * (stage.stageHeight - rect.height);
								break;
							}
							case StageAlign.BOTTOM:
							case StageAlign.BOTTOM_LEFT:
							case StageAlign.BOTTOM_RIGHT:
							{
								rect.y = stage.stageHeight - rect.height;
								break;
							}
						}
					}
					else
					{
						rect.width = stage.stageHeight * currentRatio;
						
						switch (stage.align)
						{
							case "":
							case StageAlign.TOP:
							case StageAlign.BOTTOM:
							{
								rect.x = .5 * (stage.stageWidth - rect.width);
								break;
							}
							case StageAlign.RIGHT:
							case StageAlign.TOP_RIGHT:
							case StageAlign.BOTTOM_RIGHT:
							{
								rect.x = stage.stageWidth - rect.width;
								break;
							}
						}
					}
				}
			}
			
			stage.removeEventListener(Event.RESIZE, handleStageResize, true);
			
			return rect;
		}

		/**
		 * Returns the original build width of the SWF
		 */
		public static function getBuildWidth(stage:Stage):Number
		{
			if (isNaN(_buildWidth))
			{
				if (stage.scaleMode == StageScaleMode.NO_SCALE)
				{
					stage.addEventListener(Event.RESIZE, handleStageResize, true, int.MAX_VALUE, true);
					stage.scaleMode = StageScaleMode.EXACT_FIT;
					_buildWidth = stage.stageWidth; 
					stage.scaleMode = StageScaleMode.NO_SCALE;
					stage.removeEventListener(Event.RESIZE, handleStageResize, true);
				}
				else
				{
					_buildWidth = stage.stageWidth;
				}
			}
			return _buildWidth;
		}
		
		/**
		 * Returns the original build height of the SWF
		 */
		public static function getBuildHeight(stage:Stage):Number
		{
			if (isNaN(_buildHeight))
			{
				if (stage.scaleMode == StageScaleMode.NO_SCALE)
				{
					stage.addEventListener(Event.RESIZE, handleStageResize, true, int.MAX_VALUE, true);
					stage.scaleMode = StageScaleMode.EXACT_FIT;
					_buildHeight = stage.stageHeight; 
					stage.scaleMode = StageScaleMode.NO_SCALE;
					stage.removeEventListener(Event.RESIZE, handleStageResize, true);
				}
				else
				{
					_buildHeight = stage.stageHeight;
				}
			}
			return _buildHeight;
		}
		
		private static function handleStageResize(event:Event):void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		/**
		 * @private
		 */
		public static function toString():String
		{
			return objectToString(StageUtils);
		}
	}
}
