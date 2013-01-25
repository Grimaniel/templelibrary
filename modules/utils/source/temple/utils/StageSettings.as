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

package temple.utils 
{
	import temple.core.CoreObject;
	import temple.core.display.StageProvider;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * Easy way to set properties on stage. After settings the properties the class destruct itself.
	 * 
	 * @author Thijs Broerse
	 */
	public class StageSettings extends CoreObject 
	{
		private static var _width:Number;
		private static var _height:Number;
		
		private var _displayObject:DisplayObject;
		private var _stageAlign:String;
		private var _stageScaleMode:String;

		/**
		 * Create a new StageSettings object
		 * @param displayObject a display object which is used to get the stage.
		 * @param stageAlign alignment of the stage.
		 * @param stageScaleMode scalemode of the stage.
		 * @param width width of the stage. This value will be available in StageSettings.width and can be used trough the application to get to original stage width.
		 * @param height height of the stage. This value will be available in StageSettings.height and can be used trough the application to get to original stage height.
		 */
		public function StageSettings(displayObject:DisplayObject, stageAlign:String = "TL", stageScaleMode:String = "noScale", width:Number = NaN, height:Number = NaN)
		{
			_displayObject = displayObject;
			_stageAlign = stageAlign;
			_stageScaleMode = stageScaleMode;
			
			StageSettings._width = width;
			StageSettings._height = height;
			
			if (_displayObject.stage)
			{
				apply();
			}
			else
			{
				_displayObject.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
		}
		
		/**
		 * Orgininal width of the stage. Set as parameter in the constructor of this class.
		 */
		public static function get width():Number
		{
			return StageSettings._width;
		}
		
		/**
		 * Orgininal height of the stage. Set as parameter in the constructor of this class.
		 */
		public static function get height():Number
		{
			return StageSettings._height;
		}
		
		private function apply():void
		{
			StageProvider.stage = _displayObject.stage;
			
			_displayObject.stage.align = _stageAlign;
			_displayObject.stage.scaleMode = _stageScaleMode;
			
			if (isNaN(StageSettings._width)) StageSettings._width = _displayObject.stage.stageWidth;
			if (isNaN(StageSettings._height)) StageSettings._height = _displayObject.stage.stageHeight;
			
			destruct();
		}

		private function handleAddedToStage(event:Event):void
		{
			apply();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (_displayObject)
			{
				_displayObject.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
				_displayObject = null;
			}
			super.destruct();
		}
	}
}
