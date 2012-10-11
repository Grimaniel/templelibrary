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
	import temple.core.display.CoreSprite;

	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * Basic performance meter (FPS + memory history).
	 * 
	 * @example
	 * <p>Self-contained, set .redraw to enable graph redraw (dont forget to addChild() somewhere).</p>
	 * <listing version="3.0">
	 * var stat:PerformanceStat = new PerformanceStat();
	 * this.stage.addChild(stat);
	 * </listing> 
	 *		
	 *	<p>also:</p>
	 *	
	 *	<listing version="3.0">	
	 *	stat.redraw = true/false; // set to false when not showing
	 *	stat.resetGraph(); // clear history after excessive load
	 *	</listing>
	 *	
	 *	@includeExample ../ui/animation/FrameStableMovieClipExample.as
	 *
	 * 	@author Bart van der Schoor, Geert Fokke
	 */
	public class PerformanceStat extends CoreSprite
	{
		// The memorygraph is aligned along the avarage memory in the history.
		// Here you can define how much Kb difference the graph shows.
		private static const _GRAPH_MEMORY_HEIGHT:int = 25000;
		private static const _EXTENDED_GRAPH_MEMORY_HEIGHT:int = 40000;

		private static const _UPDATE_FREQUENCY_MILLISECONDS:int = 250;

		private var _fpsField:TextField;
		private var _memoryField:TextField;

		private var _frameMilliMin:Number = 0;
		private var _frameMilliMax:Number = 0;
		private var _frameMilliTotal:Number = 0;

		private var _memoryKiloByteMin:Number = 0;
		private var _memoryKiloByteMax:Number = 0;
		private var _memoryKiloByteTotal:Number = 0;

		private var _avarageKiloByteMemory:Number = 0;

		private var _currentHistoryData:Vector.<Number>;
		private var _memoryKiloByteHistory:Vector.<Number>;
		private var _memoryKiloByteExtendedHistory:Vector.<Number>;
		private var _frameMilliSecondsHistory:Vector.<Number>;
		private var _frameMilliSecondsExtendedHistory:Vector.<Number>;

		private var _graph:Shape;
		private var _graphics:Graphics;
		private var _graphRect:Rectangle;
		private var _drawGraphLineCommands:Vector.<int>;
		private var _drawingFillCommands:Vector.<int>;
		private var _drawingLineCoordinates:Vector.<Number>;
		private var _drawingFillCoordinates:Vector.<Number>;

		// set the intial value high, so the initial state is added
		// to the extended history at the first enter frame event
		private var _updateTicks:int = 999;
		private var _frameTicks:int = 0;
		private var _lastUpdateTime:int;
		private var _maxHistoryItems:int;
		private var _fieldHeight:Number = 16;
		private var _mouseDownPosition:Point;
		private var _showExtendedHistory:Boolean;
		private var _drawGraph:Boolean = true;

		// reusables
		private var _i:int;
		private var _dx:Number;
		private var _dy:Number;
		private var _tmpY:Number;

		/**
		 * Creates a new PerformanceStat
		 * 
		 * @param visible Sets the intial visibility of the PerformanceStat, this can later be toggled by pressing Shift + ESC. 
		 * @param x Sets the x location of the PerformanceStat.
		 * @param y Sets the y location of the PerformanceStat.
		 */
		public function PerformanceStat(visible:Boolean = true, x:int = 2, y:int = 2, draggable:Boolean = true, hideable:Boolean = true)
		{
			this.visible = visible;
			this.x = x; 
			this.y = y;
			this.buttonMode = this.useHandCursor = true;

			// create and set fields
			this._fpsField = new TextField();
			this._memoryField = new TextField();
			this._memoryField.text = this._fpsField.text = "";

			this.addChild(this._fpsField);
			this.addChild(this._memoryField);

			this._fpsField.x = this._memoryField.x = this._fpsField.y = 3;
			this._memoryField.y = this._fpsField.y + this._fieldHeight;
			this._memoryField.mouseEnabled = this._fpsField.mouseEnabled = false;

			this._graphRect = new Rectangle(3, this._memoryField.y + this._fieldHeight + 3, 135, 40);

			this.setFieldFormat(this._fpsField, this._graphRect.width, this._fieldHeight, 0xae6800);
			this.setFieldFormat(this._memoryField, this._graphRect.width, this._fieldHeight, 0x0068b0);

			this._graph = new Shape();
			this._graphics = this._graph.graphics;
			this.addChild(this._graph);

			// draw background
			this.graphics.lineStyle(1, 0x808080, .5, true);
			this.graphics.beginFill(0xFFFFFF, .45);
			this.graphics.drawRoundRect(0, 0, this._graphRect.width + 6, this._graphRect.bottom + 3, 4);

			this.graphics.lineStyle(0, 0x808080, .4, true);
			this.graphics.beginFill(0xFFFFFF, .8);
			this.graphics.drawRoundRect(this._fpsField.x, this._fpsField.y, this._fpsField.width, this._fpsField.height + this._memoryField.height, 2);

			this.graphics.drawRect(this._graphRect.x, this._graphRect.y, this._graphRect.width, this._graphRect.height);
			this.graphics.endFill();

			// draw a line for the target framerate
			this.graphics.lineStyle(0, 0x808080, .4, true, LineScaleMode.NORMAL);
			this.graphics.moveTo(this._graphRect.left, this._graphRect.y + this._graphRect.height / 2);
			this.graphics.lineTo(this._graphRect.right, this._graphRect.y + this._graphRect.height / 2);


			var currentMemoryUse:Number = System.totalMemory / 1024;

			this._frameMilliSecondsHistory = Vector.<Number>([1000]);
			this._frameMilliSecondsExtendedHistory = Vector.<Number>([1000]);
			this._memoryKiloByteHistory = Vector.<Number>([currentMemoryUse]);
			this._memoryKiloByteExtendedHistory = Vector.<Number>([currentMemoryUse]);

			// already add 3 extra lineTo commands to make a full shape
			this._drawingFillCommands = Vector.<int>([1, 2, 2, 2]);
			this._drawGraphLineCommands = Vector.<int>([1]);
			this._drawingLineCoordinates = new Vector.<Number>();
			this._drawingFillCoordinates = new Vector.<Number>();


			this._maxHistoryItems = this._graphRect.width / 2;

			// Prefill the Command and History collections so we don't need to worry
			// about the length being too short and the need of adding new drawing commands.
			for (this._i = 0; this._i < this._maxHistoryItems - 1; this._i++)
			{
				this._drawGraphLineCommands.push(2);
				this._drawingFillCommands.push(2);

				this._frameMilliSecondsHistory.push(1000);
				this._memoryKiloByteHistory.push(currentMemoryUse);

				this._frameMilliSecondsExtendedHistory.push(1000);
				this._memoryKiloByteExtendedHistory.push(currentMemoryUse);
			}

			this._lastUpdateTime = getTimer();

			if (hideable && this.stage) this.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDownEvents);

			if (draggable) this.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvents, false, -1000);
			
			this.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame, false, -1000);
			this.addEventListener(Event.ADDED_TO_STAGE, this.handleAddedToStage, false, -1000);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage, false, -1000);
		}

		private function handleMouseEvents(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					this.addEventListener(MouseEvent.MOUSE_UP, handleMouseEvents, false, -1000);

					this.startDrag();
					this._mouseDownPosition = this.position;
					break;
				case MouseEvent.MOUSE_UP:
					this.removeEventListener(MouseEvent.MOUSE_UP, handleMouseEvents);

					this.stopDrag();
					// toggle the short history view / extended history view on click
					if (this._mouseDownPosition.x == this.x && this._mouseDownPosition.y == this.y) this._showExtendedHistory = !this._showExtendedHistory;
					break;
			}
		}
		
		/**
		 * 	Handles key down events.
		 * 	Shift + ESC: toggles visibility.
		 */
		private function handleKeyDownEvents(event:KeyboardEvent):void
		{
			// 27 == Keyboard.ESCAPE
			if (event.shiftKey && event.keyCode == 27) this.visible = !this.visible;
		}

		private function handleAddedToStage(event:Event):void
		{
			this.drawGraph = true;
		}

		private function handleRemovedFromStage(event:Event):void
		{
			this.drawGraph = false;
		}

		/**
		 * 	Keep track of the number of frames and memory usage
		 * 	Update the GUI if needed.
		 */ 
		private function handleEnterFrame(event:Event):void
		{
			this._memoryKiloByteTotal += (System.totalMemory / 1024);
			this._frameTicks++;
			
			var time:int = getTimer();

			if (time > this._lastUpdateTime + _UPDATE_FREQUENCY_MILLISECONDS)
			{
				// UPDATE HISTORY INFORMATION

				this._updateTicks++;

				// update fps & memory
				this._frameMilliSecondsHistory.unshift((time - this._lastUpdateTime) / this._frameTicks);
				this._memoryKiloByteHistory.unshift(this._memoryKiloByteTotal / this._frameTicks);

				this._lastUpdateTime = time;

				if (this._frameMilliSecondsHistory.length > this._maxHistoryItems) this._frameMilliSecondsHistory.length = this._memoryKiloByteHistory.length = this._maxHistoryItems;

				// check if it is time to save the current state for the extended graph
				if (this._updateTicks >= 10)
				{
					this._frameMilliSecondsExtendedHistory.unshift(this._frameMilliSecondsHistory[0]);
					this._memoryKiloByteExtendedHistory.unshift(this._memoryKiloByteHistory[0]);

					if (this._frameMilliSecondsExtendedHistory.length > this._maxHistoryItems) this._frameMilliSecondsExtendedHistory.length = this._memoryKiloByteExtendedHistory.length = this._maxHistoryItems;

					this._updateTicks = 0;
				}

				// calculate min/max
				this._frameMilliMin = this._frameMilliMax = this._frameMilliSecondsHistory[0];
				this._memoryKiloByteMin = this._memoryKiloByteMax = this._memoryKiloByteHistory[0];

				// Since both the framerate history and the memory history have
				// the same length we can calculate the min and max in the same loop
				for (this._i = 0;this._i < _maxHistoryItems; this._i++)
				{
					this._frameMilliMin = this._frameMilliSecondsHistory[this._i] < this._frameMilliMin ? this._frameMilliSecondsHistory[this._i] : this._frameMilliMin;
					this._frameMilliMax = this._frameMilliSecondsHistory[this._i] > this._frameMilliMax ? this._frameMilliSecondsHistory[this._i] : this._frameMilliMax;

					this._memoryKiloByteMin = this._memoryKiloByteHistory[this._i] < _memoryKiloByteMin ? this._memoryKiloByteHistory[this._i] : this._memoryKiloByteMin;
					this._memoryKiloByteMax = this._memoryKiloByteHistory[this._i] > this._memoryKiloByteMax ? this._memoryKiloByteHistory[this._i] : _memoryKiloByteMax;

					this._avarageKiloByteMemory += this._showExtendedHistory ? this._memoryKiloByteExtendedHistory[this._i] : this._memoryKiloByteHistory[this._i];
				}

				this._avarageKiloByteMemory = this._avarageKiloByteMemory / _maxHistoryItems;

				// reset these
				this._memoryKiloByteTotal = 0;
				this._frameTicks = 0;



				// UPDATE GUI

				// update the current info
				this._fpsField.text = "FPS: " + String(int(1000 / this._frameMilliSecondsHistory[0] * 100) / 100) + "  ( " + String(int(1000 / this._frameMilliMax * 100) / 100) + " / " + String(int(1000 / this._frameMilliMin * 100) / 100) + " )";
				this._memoryField.text = "MB:  " + String(int(_memoryKiloByteHistory[0] / 1024 * 100) / 100) + "  ( " + String(int(this._memoryKiloByteMin / 1024 * 100) / 100) + " / " + String(int(this._memoryKiloByteMax / 1024 * 100) / 100) + " )";


				if (this._drawGraph)
				{
					// prepare the graph
					this._graphics.clear();

					this._dx = this._graphRect.width / (_maxHistoryItems - 1);

					// Memory Usage Graph

					this._dy = this._graphRect.height / (this._showExtendedHistory ? _EXTENDED_GRAPH_MEMORY_HEIGHT : _GRAPH_MEMORY_HEIGHT);

					// set the current history data according to the viewing mode
					this._currentHistoryData = this._showExtendedHistory ? this._memoryKiloByteExtendedHistory : this._memoryKiloByteHistory;

					this._tmpY = this._graphRect.bottom - this._graphRect.height / 2 - (this._dy * (this._currentHistoryData[0] - this._avarageKiloByteMemory));

					if (this._tmpY > this._graphRect.bottom)
					{
						this._tmpY = this._graphRect.bottom;
					}
					else if (this._tmpY < this._graphRect.top)
					{
						this._tmpY = this._graphRect.top;
					}

					this._drawingLineCoordinates.length = this._drawingFillCoordinates.length = 0;
					this._drawingLineCoordinates.push(this._graphRect.right, this._tmpY);
					this._drawingFillCoordinates.push(this._graphRect.right, this._tmpY);

					// calculate the current Memory history drawing coordinates
					for (this._i = 1;this._i < _maxHistoryItems;this._i++)
					{
						this._tmpY = this._graphRect.bottom - this._graphRect.height / 2 - (this._dy * (this._currentHistoryData[this._i] - this._avarageKiloByteMemory));

						if (this._tmpY > this._graphRect.bottom)
						{
							this._tmpY = this._graphRect.bottom;
						}
						else if (this._tmpY < this._graphRect.top)
						{
							this._tmpY = this._graphRect.top;
						}

						this._drawingLineCoordinates.push(this._graphRect.right - this._dx * this._i, this._tmpY);
						this._drawingFillCoordinates.push(this._graphRect.right - this._dx * this._i, this._tmpY);
					}

					// complete the fill shape coordinates
					this._tmpY = this._graphRect.bottom - this._graphRect.height / 2 - (this._dy * (this._currentHistoryData[0] - this._avarageKiloByteMemory));
					this._drawingFillCoordinates.push(this._graphRect.left, this._graphRect.bottom, this._graphRect.right, this._graphRect.bottom, this._graphRect.right, this._tmpY);

					this._graphics.lineStyle();
					this._graphics.beginFill(this._showExtendedHistory ? 0x5a9ac6 : 0x0090f5, .2);
					this._graphics.drawPath(this._drawingFillCommands, this._drawingFillCoordinates);
					this._graphics.endFill();

					this._graphics.lineStyle(1, this._showExtendedHistory ? 0x5a9ac6 : 0x0090f5, 1, false, LineScaleMode.NORMAL);
					this._graphics.drawPath(this._drawGraphLineCommands, this._drawingLineCoordinates);


					// FPS Stats Graph

					// set the current history data according to the viewing mode
					this._currentHistoryData = this._showExtendedHistory ? this._frameMilliSecondsExtendedHistory : this._frameMilliSecondsHistory;

					// Calculate the FPS history line coordinates
					this._dy = this._graphRect.height / (this.stage.frameRate * 2);
					this._tmpY = this._graphRect.bottom - (this._dy * (1000 / this._currentHistoryData[0]));

					if (this._tmpY > this._graphRect.bottom)
					{
						this._tmpY = this._graphRect.bottom;
					}
					else if (this._tmpY < this._graphRect.top)
					{
						this._tmpY = this._graphRect.top;
					}

					this._drawingLineCoordinates.length = 0;
					this._drawingLineCoordinates.push(this._graphRect.right, this._tmpY);

					for (this._i = 1;this._i < _maxHistoryItems;this._i++)
					{
						this._tmpY = this._graphRect.bottom - (this._dy * (1000 / this._currentHistoryData[this._i]));

						if (this._tmpY > this._graphRect.bottom)
						{
							this._tmpY = this._graphRect.bottom;
						}
						else if (this._tmpY < this._graphRect.top)
						{
							this._tmpY = this._graphRect.top;
						}

						this._drawingLineCoordinates.push(this._graphRect.right - this._i * this._dx, this._tmpY);
					}

					// draw current fps history
					this._graphics.lineStyle(0, this._showExtendedHistory ? 0xbe8839 : 0xF59200, 1, false, LineScaleMode.NORMAL);
					this._graphics.drawPath(this._drawGraphLineCommands, this._drawingLineCoordinates);
				}
			}
		}

		/**
		 * clear the graph history, or maybe chop last X items
		 */
		public function resetGraph(chop:int = -1):void
		{
			if (chop <= 0) chop = this._maxHistoryItems;

			var chopLength:int = this._maxHistoryItems - chop;
			var currentMemory:Number = System.totalMemory / 1024;

			if (chopLength < 0) chopLength = 0;

			for (this._i = chopLength; this._i < this._maxHistoryItems; this._i++)
			{
				this._frameMilliSecondsHistory[this._i] = 1000;
				this._frameMilliSecondsExtendedHistory[this._i] = 1000;
				this._memoryKiloByteHistory[this._i] = currentMemory;
				this._memoryKiloByteExtendedHistory[this._i] = currentMemory;
			}
		}

		/**
		 * 	lazy setter
		 */ 
		private function setFieldFormat(field:TextField, width:Number = 50, height:Number = 20, color:Number = 0x000000):void
		{
			field.textColor = 0x000000;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.selectable = false;
			field.width = width;
			field.height = height;
			field.defaultTextFormat = new TextFormat("Lucida Sans", 9, color);
		}
		
		/**
		 * 	Indicates if the graph should be drawn.
		 */
		public function set drawGraph(value:Boolean):void
		{
			this._drawGraph = value;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = this.drawGraph = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this.stage) this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDownEvents);

			if (this._drawGraphLineCommands)
			{
				this._drawGraphLineCommands.length = 0;
				this._drawGraphLineCommands = null;
			}
			if (this._drawingFillCommands)
			{
				this._drawingFillCommands.length = 0;
				this._drawingFillCommands = null;
			}
			if (this._drawingLineCoordinates)
			{
				this._drawingLineCoordinates.length = 0;
				this._drawingLineCoordinates = null;
			}
			if (this._drawingFillCoordinates)
			{
				this._drawingFillCoordinates.length = 0;
				this._drawingFillCoordinates = null;
			}
			if (this._currentHistoryData)
			{
				this._currentHistoryData.length = 0;
				this._currentHistoryData = null;
			}
			if (this._frameMilliSecondsHistory)
			{
				this._frameMilliSecondsHistory.length = 0;
				this._frameMilliSecondsHistory = null;
			}
			if (this._memoryKiloByteHistory)
			{
				this._memoryKiloByteHistory.length = 0;
				this._memoryKiloByteHistory = null;
			}
			if (this._frameMilliSecondsExtendedHistory)
			{
				this._frameMilliSecondsExtendedHistory.length = 0;
				this._frameMilliSecondsExtendedHistory = null;
			}
			if (this._memoryKiloByteExtendedHistory)
			{
				this._memoryKiloByteExtendedHistory.length = 0;
				this._memoryKiloByteExtendedHistory = null;
			}

			this._graph = null;
			this._mouseDownPosition = null;
			this._fpsField = null;
			this._graphRect = null;
			this._memoryField = null;
			this._graphics = null;

			this._dx = NaN;
			this._dy = NaN;
			this._tmpY = NaN;
			this._fieldHeight = NaN;
			this._memoryKiloByteTotal = NaN;
			this._memoryKiloByteMin = NaN;
			this._frameMilliMax = NaN;
			this._memoryKiloByteMax = NaN;
			this._maxHistoryItems = NaN;
			this._frameMilliTotal = NaN;
			this._frameMilliMin = NaN;
			this._avarageKiloByteMemory = NaN;

			super.destruct();
		}
	}
}

