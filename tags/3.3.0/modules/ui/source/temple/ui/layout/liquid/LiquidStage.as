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
	import temple.core.errors.TempleArgumentError;
	import temple.core.errors.TempleError;
	import temple.core.errors.throwError;
	import temple.core.events.CoreEventDispatcher;
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
	 * <p>Note: The LiquidStage automatically sets the stageScaleMode to 'noScale' and the stageAlign to 'topLeft'.</p>
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

		/**
		 * Returns the instance of the LiquidStage.
		 * 
		 * @param stage if stage is not null an instance of the LiquidStage is created when there is
		 */
		public static function getInstance(stage:Stage):LiquidStage
		{
			return LiquidStage._instance || (stage ? new LiquidStage(stage) : null);
		}
		
		private var _minimalWidth:Number;
		private var _minimalHeight:Number;
		
		private var _resizeDelay:FrameDelay;
		private var _offset:Point = new Point(0,0);

		private var _width:Number;
		private var _height:Number;
		
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
			if (isNaN(value)) throwError(new TempleArgumentError(LiquidStage, "originalWidth can not be set to NaN"));
			
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
			if (isNaN(value)) throwError(new TempleArgumentError(LiquidStage, "originalHeight can not be set to NaN"));
			
			LiquidStage._originalHeight = value;
		}

		private var _stage:Stage;
		
		/**
		 * @private
		 * 
		 * Don't call constructor directly, use 'LiquidStage.getInstance()'
		 */
		public function LiquidStage(stage:Stage) 
		{
			if (_instance)
			{
				throwError(new TempleError(this, "instance already set, use LiquidStage.getInstance()"));
			}
			if (stage == null) throwError(new TempleArgumentError(this, "Stage can not be null"));
			
			_instance = this;
			this._stage = stage;
			this._stage.addEventListener(Event.RESIZE, this.handleStageResize, false, -1);
			
			if (this._stage.scaleMode != StageScaleMode.NO_SCALE)
			{
				this._stage.scaleMode = StageScaleMode.NO_SCALE;
				//this.logWarn("LiquidStage changed the StageScaleMode");
			}
			if (this._stage.align != StageAlign.TOP_LEFT)
			{
				this._stage.align = StageAlign.TOP_LEFT;
				//this.logWarn("LiquidStage changed the StageAlign");
			}
			new FrameDelay(this.dispatchEvent, 1, [new Event(Event.RESIZE)]);
		}
		
		/**
		 * Returns the stageWidth or minimalWidth or width
		 */
		public function get width():Number
		{
			if (!isNaN(this._width)) return this._width;
			return isNaN(this._minimalWidth) || this._stage.stageWidth > this._minimalWidth ? this._stage.stageWidth : this._minimalWidth;
		}

		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			this._width = value;
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
			if (!isNaN(this._height)) return this._height;
			return isNaN(this._minimalHeight) || this._stage.stageHeight > this._minimalHeight ? this._stage.stageHeight : this._minimalHeight;
		}

		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			this._height = value;
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
			if (this._resizeDelay) this._resizeDelay.destruct();
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
