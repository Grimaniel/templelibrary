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
			this._displayObject = displayObject;
			this._stageAlign = stageAlign;
			this._stageScaleMode = stageScaleMode;
			
			StageSettings._width = width;
			StageSettings._height = height;
			
			if (this._displayObject.stage)
			{
				this.apply();
			}
			else
			{
				this._displayObject.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
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
			StageProvider.stage = this._displayObject.stage;
			
			this._displayObject.stage.align = this._stageAlign;
			this._displayObject.stage.scaleMode = this._stageScaleMode;
			
			if (isNaN(StageSettings._width)) StageSettings._width = this._displayObject.stage.stageWidth;
			if (isNaN(StageSettings._height)) StageSettings._height = this._displayObject.stage.stageHeight;
			
			this.destruct();
		}

		private function handleAddedToStage(event:Event):void
		{
			this.apply();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._displayObject)
			{
				this._displayObject.removeEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage);
				this._displayObject = null;
			}
			super.destruct();
		}
	}
}
