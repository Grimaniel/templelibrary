/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
	import temple.core.CoreEventDispatcher;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.utils.FrameDelay;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * Singleton class for wrapping the Stage as a LiquidObject for aligning other LiquidObject to the stage.
	 * The LiquidStage is not actually a Stage, but has the Stage (composition).
	 * 
	 * <p>Note: The LiquidStage automaticly sets the stageScaleMode to 'noScale' and the stageAlign to 'topLeft'.</p>
	 * 
	 * @includeExample LiquidExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public final class LiquidStage extends CoreEventDispatcher implements ILiquidRelatedObject
	{
		private static var _originalWidth:Number;
		private static var _originalHeight:Number;
		
		private static var _instance:LiquidStage;
		
		private var _minimalWidth:Number;
		private var _minimalHeight:Number;
		
		private var _resizeDelay:FrameDelay;
		private var _offset:Point = new Point(0,0);

		/**
		 * Returns the instance of the LiquidStage
		 */
		public static function getInstance():LiquidStage
		{
			return LiquidStage._instance;
		}
		
		/**
		 * The original width of the stage. Only needed if you want to use relative positions
		 */
		public static function get originalWidth():Number
		{
			return LiquidStage._originalWidth;
		}
		
		/**
		 * @private
		 */
		public static function set originalWidth(value:Number):void
		{
			if(isNaN(value)) throwError(new TempleArgumentError(LiquidStage, "originalWidth can not be set to NaN"));
			
			LiquidStage._originalWidth = value;
		}
		
		/**
		 * The original height of the stage. Only needed if you want to use relative positions
		 */
		public static function get originalHeight():Number
		{
			return LiquidStage._originalHeight;
		}
		
		/**
		 * @private
		 */
		public static function set originalHeight(value:Number):void
		{
			if(isNaN(value)) throwError(new TempleArgumentError(LiquidStage, "originalHeight can not be set to NaN"));
			
			LiquidStage._originalHeight = value;
		}

		private var _stage:Stage;
		
		/**
		 * Don't call constructor directly, use 'LiquidStage.getInstance()'
		 */
		public function LiquidStage(stage:Stage) 
		{
			if(_instance)
			{
				throwError(new TempleError(this, "instance already set, use LiquidStage.getInstance()"));
			}
			if(stage == null) throwError(new TempleArgumentError(this, "Stage can not be null"));
			
			_instance = this;
			this._stage = stage;
			this._stage.addEventListener(Event.RESIZE, this.handleStageResize, false, -1);
			
			if(this._stage.scaleMode != StageScaleMode.NO_SCALE)
			{
				this._stage.scaleMode = StageScaleMode.NO_SCALE;
				//this.logWarn("LiquidStage changed the StageScaleMode");
			}
			if(this._stage.align != StageAlign.TOP_LEFT)
			{
				this._stage.align = StageAlign.TOP_LEFT;
				//this.logWarn("LiquidStage changed the StageAlign");
			}
			new FrameDelay(this.dispatchEvent, 1, [new Event(Event.RESIZE)]);
		}
		
		/**
		 * Returns the stageWidth or minimalWidth
		 */
		public function get width():Number
		{
			return isNaN(this._minimalWidth) || this._stage.stageWidth > this._minimalWidth ? this._stage.stageWidth : this._minimalWidth;
		}

		/**
		 * @inheritDoc
		 * 
		 * Always 1 on the stage
		 */
		public function get scaleX():Number
		{
			return 1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get minimalWidth():Number
		{
			return this._minimalWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimalWidth(value:Number):void
		{
			this._minimalWidth = value;
		}
		
		/**
		 * Returns the stageHeight or minimalHeight
		 */
		public function get height():Number
		{
			return isNaN(this._minimalHeight) || this._stage.stageHeight > this._minimalHeight ? this._stage.stageHeight : this._minimalHeight;
		}

		/**
		 * @inheritDoc
		 */
		public function get minimalHeight():Number
		{
			return this._minimalHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minimalHeight(value:Number):void
		{
			this._minimalHeight = value;
		}

		/**
		 * @inheritDoc
		 * 
		 * Always 1 on the stage
		 */
		public function get scaleY():Number
		{
			return 1;
		}

		/**
		 * @inheritDoc
		 */
		public function get displayObject():DisplayObject
		{
			return this._stage;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Always null on stage
		 */
		public function get relatedObject():ILiquidRelatedObject
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Always true on stage
		 */
		public function get resetRelatedScale():Boolean
		{
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get offset():Point
		{
			return this._offset;
		}
		
		private function handleStageResize(event:Event):void
		{
			this.dispatchEvent(event.clone());
			if(this._resizeDelay) this._resizeDelay.destruct();
			this._resizeDelay = new FrameDelay(this.delayedResize, 2);
		}

		private function delayedResize():void 
		{
			this._resizeDelay = null;
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			LiquidStage._instance = null;
			if (this._resizeDelay)
			{
				this._resizeDelay.destruct();
				this._resizeDelay = null;
			}
			super.destruct();
		}
	}
}
